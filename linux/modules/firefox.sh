#!/usr/bin/env bash
# Firefox extensions via enterprise policy.
#
# Same idea as the brave module, different schema and different path:
#   - Firefox wraps everything in a top-level "policies" key; Chromium is flat.
#   - Extensions are addressed by AMO GUID with an install_url, not by a Chrome
#     Web Store ID with an update_url.
#
# Firefox here is the Ubuntu **snap**, which does not read a `distribution/`
# directory (there isn't one in the squashfs). It reads /etc/firefox, which the
# snap reaches through a connected `system-files` plug named `firefox:etc-firefox`.
# Verify that plug is connected before assuming a policy will be seen:
#   snap connections firefox | grep etc-firefox
#
# This module does NOT install Firefox -- Ubuntu ships it. It only configures it.

FIREFOX_POLICY_SRC="$OSZ_SHARED/firefox/policies.json"
FIREFOX_POLICY_DIR="/etc/firefox/policies"
FIREFOX_POLICY_DEST="$FIREFOX_POLICY_DIR/policies.json"

install_firefox () {
	require_linux || return 1

	if ! have firefox; then
		skip "firefox not installed; nothing to configure"
		return 0
	fi

	# The snap can only see /etc/firefox if that plug is connected. A missing
	# connection is silent -- Firefox simply ignores the policy file.
	if snap list firefox >/dev/null 2>&1; then
		if snap connections firefox 2>/dev/null | grep -q "firefox:etc-firefox.*:system-files"; then
			ok "snap plug firefox:etc-firefox is connected"
		else
			warn "snap plug firefox:etc-firefox is NOT connected -- policies will be ignored."
			warn "Connect it with: sudo snap connect firefox:etc-firefox"
		fi
	fi

	deploy_firefox_policy
}

deploy_firefox_policy () {
	[[ -f $FIREFOX_POLICY_SRC ]] || { err "missing $FIREFOX_POLICY_SRC"; return 1; }
	jq empty "$FIREFOX_POLICY_SRC" 2>/dev/null || { err "$FIREFOX_POLICY_SRC is not valid JSON"; return 1; }

	# Copied, not symlinked -- same reasoning as the Brave policy: a managed
	# policy should be root-owned and not user-writable.
	sudo install -d -m 0755 "$FIREFOX_POLICY_DIR"
	sudo install -m 0644 -o root -g root "$FIREFOX_POLICY_SRC" "$FIREFOX_POLICY_DEST"
	ok "deployed policy -> $FIREFOX_POLICY_DEST"
	log "Fully quit Firefox (every window) and relaunch, then check about:policies."
}

update_firefox () {
	require_linux || return 1
	deploy_firefox_policy
}

uninstall_firefox () {
	require_linux || return 1
	sudo rm -f "$FIREFOX_POLICY_DEST"
	ok "removed $FIREFOX_POLICY_DEST"
}
