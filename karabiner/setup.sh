#!/usr/bin/env bash
#
# set up karabiner

local title=Karabiner
local seil_cli=/Applications/Seil.app/Contents/Library/bin/seil
local karabiner_cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

function setup_karabiner () {
	# setup seil (so capslock can work with hyper key)
	# $seil_cli set enable_capslock 1
	# /bin/echo -n .
	# $seil_cli set keycode_capslock 80
	# /bin/echo -n .

	# symlink karabiner's config
	link_file "$OSZ_ROOT/karabiner/Karabiner" "$HOME/Library/Application Support/Karabiner"

	# set up key bindings
	reset_bindings

	# launch seil and karabiner
	$seil_cli relaunch
	$karabiner_cli relaunch

	log 'Completed setup.' success
}

function reset_bindings () {
	$karabiner_cli enable private.swapleftctrlfn
	$karabiner_cli enable private.capslock_hyper
	$karabiner_cli enable private.keyboardmouse.f1_click
	$karabiner_cli enable private.keyboardmouse.f2_click
	$karabiner_cli enable private.keyboardmouse.tilde_leftclick
	$karabiner_cli enable private.functionkeys.brightness
	$karabiner_cli enable private.functionkeys.volume
}

can_continue 'Set up Karabiner?' 'Skipped Karabiner setup' && setup_karabiner