#!/usr/bin/env bash

local title=macOS

# set macOS defaults
function configure_mac_os () {
	log "Configuring macOS (you may be asked for your password)..."
	./mac-os/set-defaults.sh
	log "Configuration complete." success
}

function update_apps () {
	# install updates from the app store
	log "Updating apps from the app store..."
	sudo softwareupdate -i -a
	log "App store apps updated." success
}

can_continue 'Reset configuration?' 'Skipped macOS configuration' && configure_mac_os
can_continue 'Update apps from the app store?' 'Skipped macOS setup' && update_apps