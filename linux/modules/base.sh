#!/usr/bin/env bash
# Base prerequisites shared by every other module.

install_base () {
	require_linux || return 1

	if ! grep -qi ubuntu /etc/os-release; then
		warn "Not an Ubuntu derivative; the apt repos below may not match this distro."
		confirm "Continue?" n || return 1
	fi

	apt_refresh
	apt_install "${APT_BASE_PACKAGES[@]}"
}

update_base () {
	# The apt upgrade in linux/update already covers these.
	skip "base packages are covered by the apt upgrade"
}

uninstall_base () {
	# These are ordinary system tools that other things depend on. Removing them
	# because OS Zimmee happened to install them would be actively harmful.
	skip "base packages are left in place by design"
}
