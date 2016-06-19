#!/usr/bin/env bash
#
# install sublime

local title=Sublime
local package_control_file="$HOME/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package"

function setup_sublime () {
	local overwrite_all=false backup_all=false skip_all=false

	# symlink all user preferences
	link_file "$OSZ_ROOT/sublime/Packages" "$HOME/Library/Application Support/Sublime Text 3/Packages"
	# install package control
	if [ -f "$package_controle_file" ]; then
		can_overwrite 'Package control is already installed. Reinstall?' && curl http://sublime.wbond.net/Package%20Control.sublime-package -o $package_control_file
	fi
	# add sublime command
	if [ ! -f /usr/local/bin/sublime ]; then
		ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime
		log 'Added sublime command to command line.' success
	fi
	# set as default text editor
	defaults write com.apple.LaunchServices LSHandlers -array-add '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.3;}'

	log "completed set up." success
}

can_continue 'Set up Sublime?' 'Skipped Sublime setup' && setup_sublime