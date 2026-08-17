#!/usr/bin/env bash
# Warp terminal.
#
# No config files are tracked here on purpose: Warp keeps its settings, themes
# and workflows server-side against your account, and its local
# ~/.config/warp-terminal/ files are machine-generated state, not config worth
# versioning. Installation is the only reproducible part.

install_warp () {
	require_linux || return 1

	local name key repo
	IFS='|' read -r name key repo <<< "$APT_REPO_WARP"
	apt_repo "$name" "$key" "$repo" || return 1
	apt_install warp-terminal || return 1

	log "Warp requires a sign-in on first launch."
}

uninstall_warp () {
	require_linux || return 1
	apt_remove warp-terminal
	apt_repo_remove warpdotdev
}
