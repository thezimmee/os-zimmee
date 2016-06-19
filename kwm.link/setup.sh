#!/usr/bin/env bash
#
# setup kwm tiling window manager

local title=kwm

function install_kwm () {
	# install from github
	log "not detected; downloading kwm..."
	kwm_repo=https://github.com/koekeishiya/kwm.git
	if [ -f "$HOME/.ssh" ]
	then
		kwm_repo=git@github.com:koekeishiya/kwm.git
	fi

	git clone $kwm_repo "$HOME/Applications/kwm"
	cd "$HOME/Applications/kwm"
	make install

	log "installation complete." success
}

function setup_kwm () {
	# set up kwm to autostart
	function copy_plist () {
		if [ ! -f "$CONFIG__launch_dir" ]; then
			mkdir -p "$CONFIG__launch_dir"
		fi
		cat "$HOME/Applications/kwm/examples/com.koekeishiya.kwm.plist" | sed -e "s|/path/to/kwm|$HOME/Applications/kwm/bin/kwmLJ|" > "$CONFIG__launch_dir/com.koekeishiya.kwm.plist"
	}

	# symlink config
	if [ -f "$CONFIG__kwm_plist_file" ]; then
		can_overwrite 'plist file already exists. Overwrite it?' 'Skipped plist file; already exists' && copy_plist
	else
		copy_plist
	fi

	# launch kwm
	launchctl unload $HOME/Library/LaunchAgents/com.koekeishiya.kwm.plist
	launchctl load -w $HOME/Library/LaunchAgents/com.koekeishiya.kwm.plist

	log 'Completed setup.' success
}

# install kwm, if not already installed
if [ ! -d "$CONFIG__kwm_app_dir" ]; then
	can_continue 'kwm is not installed yet... would you like to install it?' 'kwm is already installed... skipping installation' && install_kwm
fi

# setup kwm config
can_continue 'Set up kwm?' 'Skipped kwm setup' && setup_kwm