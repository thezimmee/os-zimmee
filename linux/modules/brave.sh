#!/usr/bin/env bash
# Brave browser, plus its extensions via Chromium enterprise policy.
#
# There is no CLI for installing a browser extension. The only scriptable route
# is the enterprise-policy file that Chromium reads at startup -- on Linux a
# plain JSON file on disk, with no server or enrolment involved.

BRAVE_POLICY_SRC="$OSZ_SHARED/brave/policies-managed.json"
BRAVE_POLICY_DIR="/etc/brave/policies/managed"
BRAVE_POLICY_DEST="$BRAVE_POLICY_DIR/os-zimmee.json"

install_brave () {
	require_linux || return 1

	local name key repo
	IFS='|' read -r name key repo <<< "$APT_REPO_BRAVE"
	apt_repo "$name" "$key" "$repo" || return 1
	apt_install brave-browser || return 1

	deploy_brave_policy
}

deploy_brave_policy () {
	[[ -f $BRAVE_POLICY_SRC ]] || { err "missing $BRAVE_POLICY_SRC"; return 1; }
	jq empty "$BRAVE_POLICY_SRC" 2>/dev/null || { err "$BRAVE_POLICY_SRC is not valid JSON"; return 1; }

	# Copied rather than symlinked, unlike most config in this repo. A managed
	# policy is meant to be root-owned and not user-writable; pointing it at a
	# file under $HOME would undermine that. Re-running this module is how you
	# push an edit.
	sudo install -d -m 0755 "$BRAVE_POLICY_DIR"
	sudo install -m 0644 -o root -g root "$BRAVE_POLICY_SRC" "$BRAVE_POLICY_DEST"
	ok "deployed policy -> $BRAVE_POLICY_DEST"
	log "Verify at brave://policy after restarting Brave (extensions land on first launch)."
}

update_brave () {
	require_linux || return 1
	# Brave itself updates through apt; only the policy needs re-pushing.
	deploy_brave_policy
}

uninstall_brave () {
	require_linux || return 1
	sudo rm -f "$BRAVE_POLICY_DEST"
	apt_remove brave-browser
	apt_repo_remove brave-browser
}
