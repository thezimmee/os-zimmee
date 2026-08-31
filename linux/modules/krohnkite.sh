#!/usr/bin/env bash
# Krohnkite -- dynamic tiling for KWin.
#
# Installed from the anametologin fork, which is the maintained Plasma 6 port.
# The original esjeon/krohnkite stalled at v0.8.1 and does not run on KWin 6.
# The release carries an unversioned krohnkite.kwinscript asset that always
# tracks the newest build, so there is no version to bump here.
#
# Source moved from GitHub to Codeberg on 2025-12-11 -- the maintainer archived
# github.com/anametologin/krohnkite (read-only, no further releases there) and
# continues at codeberg.org/anametologin/Krohnkite (note the capital K; the
# GitHub repo name was lowercase). Codeberg runs Forgejo, not GitHub's release
# software, so the "always the newest release" URL has a different shape:
# Forgejo's alias is /releases/download/latest/<asset>, not GitHub's
# /releases/latest/download/<asset>. Verified live: it resolves to the newest
# STABLE release (0.9.9.2), skipping a newer 0.9.9.3_beta prerelease -- the
# same non-prerelease semantics the old GitHub URL had.
KROHNKITE_URL="https://codeberg.org/${KROHNKITE_REPO:-anametologin/Krohnkite}/releases/download/latest/${KROHNKITE_ASSET:-krohnkite.kwinscript}"
KROHNKITE_SETTINGS="$OSZ_LINUX/config/krohnkite/kwinrc.conf"

_krohnkite_installed () {
	kpackagetool6 --type=KWin/Script --list 2>/dev/null | grep -qi krohnkite
}

_krohnkite_deploy () {
	local action="$1" tmp
	have kpackagetool6 || { err "kpackagetool6 not found"; return 1; }

	tmp="$(mktemp -d)"
	log "downloading krohnkite from ${KROHNKITE_URL}"
	if ! curl -fsSL "$KROHNKITE_URL" -o "$tmp/krohnkite.kwinscript"; then
		err "download failed"; rm -rf "$tmp"; return 1
	fi
	# The asset is a zip; a redirect to an HTML error page would otherwise be
	# handed to kpackagetool6 as if it were a package.
	if ! unzip -tq "$tmp/krohnkite.kwinscript" >/dev/null 2>&1; then
		err "downloaded file is not a valid package"; rm -rf "$tmp"; return 1
	fi

	kpackagetool6 --type=KWin/Script "--${action}" "$tmp/krohnkite.kwinscript"
	local rc=$?
	rm -rf "$tmp"
	return $rc
}

install_krohnkite () {
	require_linux || return 1
	require_kde || return 1

	if _krohnkite_installed; then
		log "krohnkite already installed; upgrading in place"
		_krohnkite_deploy upgrade || return 1
	else
		_krohnkite_deploy install || return 1
	fi

	# A KWin script is inert until explicitly enabled in kwinrc.
	kwriteconfig6 --file kwinrc --group Plugins --key krohnkiteEnabled true
	ok "enabled krohnkite in kwinrc"

	apply_krohnkite_settings
}

apply_krohnkite_settings () {
	local line key value applied=0
	[[ -f $KROHNKITE_SETTINGS ]] || { skip "no krohnkite settings file"; return 0; }

	while IFS= read -r line; do
		line="${line%%#*}"
		[[ -z "${line// }" ]] && continue
		key="${line%%=*}"; value="${line#*=}"
		key="$(echo "$key" | xargs)"; value="$(echo "$value" | xargs)"
		[[ -z $key ]] && continue
		kwriteconfig6 --file kwinrc --group "Script-krohnkite" --key "$key" "$value" \
			&& applied=$((applied + 1))
	done < "$KROHNKITE_SETTINGS"

	log "applied ${applied} krohnkite settings"
	_krohnkite_reload
}

# Krohnkite reads its settings ONCE, when the script loads. `kwin reconfigure`
# alone does not re-read them -- gaps written to [Script-krohnkite] keep the old
# values and the change looks like it silently failed. Toggling the plugin off
# and on forces a genuine reload.
_krohnkite_reload () {
	have qdbus6 || { warn "qdbus6 missing; log out and back in to apply"; return 0; }
	kwriteconfig6 --file kwinrc --group Plugins --key krohnkiteEnabled false
	qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1
	sleep 1
	kwriteconfig6 --file kwinrc --group Plugins --key krohnkiteEnabled true
	qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1
	ok "krohnkite reloaded (settings re-read)"
}

update_krohnkite () {
	require_linux || return 1
	_krohnkite_installed || { skip "krohnkite not installed"; return 0; }
	_krohnkite_deploy upgrade || return 1
	apply_krohnkite_settings
	ok "krohnkite updated"
}

uninstall_krohnkite () {
	require_linux || return 1
	kwriteconfig6 --file kwinrc --group Plugins --key krohnkiteEnabled false
	_krohnkite_installed && kpackagetool6 --type=KWin/Script --remove krohnkite
	have qdbus6 && qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null
	ok "krohnkite disabled and removed"
}
