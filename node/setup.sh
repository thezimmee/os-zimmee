#!/usr/bin/env bash
#
# node and npm packages

local title=node

# Global npm modules to install.
local npm_globals=(
	"gulpjs/gulp-cli#4.0"
)

# Update npm and install global modules.
function update_npm () {
	local count_installed=0 count_skipped=0
	npm update -g npm
	for package in "${npm_packages[@]}"; do
		if test $(npm list "${package}"); then
 			log "Installing npm package: ${package}..."
 			npm install -g "${package}"
 			(($count_installed++))
 		else
 			log "${package} already installed." success
 			((count_skipped++))
 		fi
	done

	log "${BLUE}${count_installed}${END_COLOR} npm packages installed; ${BLUE}${count_skipped}${END_COLOR} already installed." success
}

if test ! $(which node); then
	fail 'Node does not appear to be installed. Make sure homebrew is configured to install it.' true
else
	update_npm
fi