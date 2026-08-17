#!/usr/bin/env bash
# KDE Plasma settings: the launcher binding and the Hyper-key collision fixes.
#
# IMPORTANT -- how shortcuts apply on Plasma 6 Wayland:
# there is no standalone kglobalaccel daemon any more (plasma-kglobalaccel.service
# is inert); KWin hosts the global-shortcut registry in-process. Edits to
# kglobalshortcutsrc are therefore only guaranteed to be live after a full
# logout/login. `kwin reconfigure` picks up the [kwin] group but not the rest.

KDE_SHORTCUTS_CONF="$OSZ_LINUX/config/kde/shortcuts.conf"
KDE_TOUCHPAD_CONF="$OSZ_LINUX/config/kde/touchpad.conf"

install_kde () {
	require_linux || return 1
	require_kde || return 1
	have kwriteconfig6 || { err "kwriteconfig6 not found"; return 1; }

	# kglobalshortcutsrc is a live file owned by KWin and holds every shortcut on
	# the system, not just ours. Back it up before touching it.
	local rc="$HOME/.config/kglobalshortcutsrc"
	if [[ -f $rc && ! -f "${rc}.osz-original" ]]; then
		cp "$rc" "${rc}.osz-original"
		ok "backed up original -> ${rc}.osz-original"
	fi

	apply_kde_shortcuts || return 1
	apply_kde_touchpad

	if have qdbus6; then
		qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null && ok "kwin reconfigured"
	fi

	warn "Log out and back in for all shortcut changes to take effect."
	warn "Then verify with: bash linux/modules/kde.sh --verify"
}

apply_kde_shortcuts () {
	local line group key value groups=() g applied=0
	[[ -f $KDE_SHORTCUTS_CONF ]] || { err "missing $KDE_SHORTCUTS_CONF"; return 1; }

	while IFS= read -r line; do
		line="${line%%#*}"
		[[ -z "${line// }" ]] && continue

		IFS='|' read -r group key value <<< "$line"
		[[ -z $group || -z $key ]] && continue

		# KDE separates multiple shortcuts with a literal tab.
		value="${value//\\t/$'\t'}"

		# Nested groups are expressed as a/b and become repeated --group flags.
		IFS='/' read -ra groups <<< "$group"
		local args=(--file kglobalshortcutsrc)
		for g in "${groups[@]}"; do args+=(--group "$g"); done
		args+=(--key "$key" "$value")

		if kwriteconfig6 "${args[@]}"; then
			ok "set [${group}] ${key}"
			applied=$((applied + 1))
		else
			warn "failed to set [${group}] ${key}"
		fi
	done < "$KDE_SHORTCUTS_CONF"

	log "applied ${applied} shortcut entries"
	[[ $applied -gt 0 ]]
}

# kcminputrc keys a touchpad by decimal vendor/product plus its name, e.g.
#   [Libinput][11311][37][VEN_2C2F:00 2C2F:0025 Touchpad]
# Those IDs are machine-specific, so discover them from the kernel rather than
# hardcoding this laptop's.
_touchpad_groups () {
	# Emit hex from awk and convert in bash: Ubuntu's default awk is mawk, which
	# has no strtonum() (that is a gawk builtin).
	awk '
		/^I: / {
			vendor=""; product=""
			if (match($0, /Vendor=[0-9a-fA-F]+/))  vendor  = substr($0, RSTART+7, RLENGTH-7)
			if (match($0, /Product=[0-9a-fA-F]+/)) product = substr($0, RSTART+8, RLENGTH-8)
		}
		/^N: Name=/ {
			name=$0
			sub(/^N: Name="/, "", name); sub(/"$/, "", name)
			if (name ~ /[Tt]ouchpad/ && vendor != "" && product != "")
				printf "%s|%s|%s\n", vendor, product, name
		}
	' /proc/bus/input/devices | while IFS='|' read -r v p n; do
		printf '%d|%d|%s\n' "$((16#$v))" "$((16#$p))" "$n"
	done | sort -u
}

apply_kde_touchpad () {
	local groups line vendor product name key value applied=0
	[[ -f $KDE_TOUCHPAD_CONF ]] || { skip "no touchpad config"; return 0; }

	groups="$(_touchpad_groups)"
	if [[ -z $groups ]]; then
		warn "no touchpad found in /proc/bus/input/devices; skipping touchpad settings"
		return 0
	fi

	while IFS='|' read -r vendor product name; do
		[[ -z $name ]] && continue
		while IFS= read -r line; do
			line="${line%%#*}"
			[[ -z "${line// }" ]] && continue
			key="${line%%=*}"; value="${line#*=}"
			key="$(echo "$key" | xargs)"; value="$(echo "$value" | xargs)"
			[[ -z $key ]] && continue
			if kwriteconfig6 --file kcminputrc \
				--group Libinput --group "$vendor" --group "$product" --group "$name" \
				--key "$key" "$value"; then
				ok "touchpad [$name] ${key}=${value}"
				applied=$((applied + 1))
			else
				warn "failed to set ${key} on [$name]"
			fi
		done < "$KDE_TOUCHPAD_CONF"
	done <<< "$groups"

	log "applied ${applied} touchpad settings"
}

# Is a shortcut already claimed? Prints every owner, empty if free.
#
# Two traps this avoids, both of which silently produce wrong answers:
#   - awk's ~ treats the pattern as a REGEX, so "Meta+Shift+L" reads "+" as a
#     quantifier and matches almost nothing.
#   - substring matching reports "Meta+Ctrl+Esc" as an owner of "Meta+Ctrl+E".
#   - KConfig writes the multi-shortcut separator as a LITERAL two-character
#     "\t" in the file, not a real tab, so splitting on an actual tab silently
#     fails to explode "Ctrl+Alt+L\tScreensaver" and reports it free.
# Compare each exploded token for exact equality.
kde_shortcut_owner () {
	local want="$1" rc="$HOME/.config/kglobalshortcutsrc"
	awk -F= -v want="$want" '
		/^\[/ { sec=$0; next }
		NF < 2 { next }
		{
			key=$1
			rest=substr($0, index($0,"=")+1)
			split(rest, fields, ",")
			active=fields[1]
			if (active == "" || active == "none") next
			n=split(active, toks, /\\t/)
			for (i=1; i<=n; i++) if (toks[i] == want) print sec "  " key
		}
	' "$rc"
}

# Read back what actually landed in the live config.
verify_kde_shortcuts () {
	local rc="$HOME/.config/kglobalshortcutsrc"
	echo "--- Super+Space (launcher) ---"
	grep -n "Meta+Space" "$rc" || warn "Super+Space NOT present in $rc"
	echo
	echo "--- touchpad: DisableEventsOnExternalMouse (must be false with keyd) ---"
	grep -n "DisableEventsOnExternalMouse" "$HOME/.config/kcminputrc" || warn "not set"
	echo
	echo "--- remaining active Super+Ctrl bindings ---"
	# Only the first comma-separated field is the *active* binding; a disabled
	# entry keeps Meta+Ctrl in its default field, so match on the field itself.
	awk -F= '/^\[/{sec=$0} /Meta\+Ctrl/ {split($2,a,","); if (a[1] != "none") print sec"  ->  "$0}' "$rc" \
		|| echo "(none remaining)"
}

update_kde () { install_kde; }

uninstall_kde () {
	require_linux || return 1
	warn "Shortcut overrides are not auto-reverted."
	warn "Reset them in System Settings > Shortcuts, or delete the entries from:"
	warn "  ~/.config/kglobalshortcutsrc"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	case "${1:-}" in
		--verify)
			source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"
			verify_kde_shortcuts ;;
		--owner)
			shift
			[[ -z ${1:-} ]] && { echo "usage: kde.sh --owner 'Meta+Ctrl+B'" >&2; exit 1; }
			out="$(kde_shortcut_owner "$1")"
			if [[ -z $out ]]; then echo "FREE: $1"; else echo "TAKEN: $1"; echo "$out"; fi ;;
	esac
fi
