local HYPER = {
	key = {'ctrl', 'alt'},
	cmd = {'ctrl', 'alt', 'cmd'},
	shift = {'ctrl', 'alt', 'shift'},
	cmd_shift = {'ctrl', 'alt', 'shift', 'cmd'},
}
local WindowGrid = hs.loadSpoon('WindowGrid')
WindowGrid:bindHotkeys(hs.hotkey.new(HYPER.key, 'o'))