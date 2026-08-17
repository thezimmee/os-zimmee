#!/usr/bin/env bash
# keyd -- CapsLock as a Hyper key. Works on Wayland because keyd operates at the
# evdev layer, below the display server.
#
# keyd 2.5.0 ships in Ubuntu universe, so no third-party repo is needed.

KEYD_CONF_SRC="$OSZ_LINUX/config/keyd/default.conf"
KEYD_CONF_DEST="/etc/keyd/default.conf"

# Debian and Ubuntu ship the binary as `keyd.rvaiya`, not `keyd` -- there is no
# alternatives entry and no `keyd` alias, and the systemd unit calls the full
# path. Upstream and most other distros use plain `keyd`, so resolve it rather
# than hardcoding either name.
_keyd_bin () {
	local b
	for b in keyd keyd.rvaiya; do
		if command -v "$b" >/dev/null 2>&1; then echo "$b"; return 0; fi
	done
	err "keyd binary not found (looked for: keyd, keyd.rvaiya)"
	return 1
}

install_keyd () {
	require_linux || return 1

	apt_install keyd

	# Symlinked, not copied, so edits in the repo take effect on `keyd reload`.
	sudo_symlink "$KEYD_CONF_SRC" "$KEYD_CONF_DEST" || return 1

	# Membership in the keyd group is what allows `keyd monitor` to run without
	# sudo. It only takes effect on the next login.
	if ! id -nG "$USER" | grep -qw keyd; then
		if getent group keyd >/dev/null; then
			sudo usermod -aG keyd "$USER"
			warn "Added $USER to the 'keyd' group -- log out and back in for it to apply."
		fi
	else
		skip "$USER already in the keyd group"
	fi

	local bin; bin="$(_keyd_bin)" || return 1

	sudo systemctl enable --now keyd || return 1

	# The package postinst starts keyd before this module links the config in, so
	# a reload here is not optional -- without it the daemon runs with whatever
	# config existed at package-install time (i.e. none).
	sudo "$bin" reload || return 1

	# A running daemon proves nothing: if keyd starts before the config exists it
	# comes up with no bindings and silently *ignores* every keyboard.
	#
	# keyd 2.5.0 has no subcommand that reports grabbed devices (its verbs are
	# monitor / list-keys / reload / listen / bind -- an invalid one prints usage
	# and exits 0, which will happily fool a naive check). The journal is the
	# only place it states what it grabbed, so assert against that.
	_keyd_verify
}

# Inspect only the window since the most recent config parse: `tac` reverses the
# log and `sed .../q` stops at that line, so older runs cannot produce a stale pass.
_keyd_verify () {
	local window
	window="$(journalctl -u keyd --no-pager -n 200 2>/dev/null | tac | sed '/CONFIG: parsing/q')"

	if [[ -z $window ]]; then
		warn "could not read the keyd journal; verify manually: journalctl -u keyd -n 30"
		return 0
	fi
	if grep -qiE "ERROR|failed to parse" <<< "$window"; then
		err "keyd reported a config error:"
		grep -iE "ERROR|failed to parse" <<< "$window" | sed 's/^/      /'
		return 1
	fi
	if ! grep -q "DEVICE: match" <<< "$window"; then
		err "keyd loaded the config but grabbed NO keyboards."
		err "Check: journalctl -u keyd -n 30"
		return 1
	fi

	ok "keyd grabbed:"
	grep "DEVICE: match" <<< "$window" | sed 's/.*(\(.*\))/      \1/' | sort -u
	return 0
}

update_keyd () {
	require_linux || return 1
	local bin; bin="$(_keyd_bin)" || return 1
	sudo "$bin" reload && ok "keyd config reloaded"
}

uninstall_keyd () {
	require_linux || return 1
	sudo systemctl disable --now keyd 2>/dev/null
	[[ -L $KEYD_CONF_DEST ]] && sudo rm -f "$KEYD_CONF_DEST" && ok "removed $KEYD_CONF_DEST"
	apt_remove keyd
}
