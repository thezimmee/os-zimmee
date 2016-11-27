--[[
@TODOs:
	- add bindings for mouse clicks
	- refactor:
		- refactor hyper to be able to dynamically add bindings
		- refactor grid to functions (bindings are customizable)
		- add all key bindings in init (or key bindings module)
	- create bindings for precise window resizing and movement
	- create layouts
		- "type" of windows get placed on certain spots or screens (i.e., important apps get placed in specific spots while others get piled away)
		- ability to save layouts?
	- create app "tabs" for multiple instances of an app?
--]]

-- load config
local config = dofile('config.lua')

-- hyper key
local hyper = dofile('helpers/hyper.lua')

-- helpers
local utils = dofile('helpers/utils.lua')

-- components
local grid = dofile('grid.lua')

-- locals
local WINDOW_MODES = {'hs', 'amethyst', 'kwm'}
local WINDOW_MODE = 'hs'

-- Ensure IPC command line client is available
-- hs.ipc.cliInstall()


-- [[ WINDOW MANAGER ]]
--  toggle amethyst
local AMETHYST_OPEN = false
local function toggleAmethyst()
	if AMETHYST_OPEN then
		hs.execute('killall Amethyst')
		AMETHYST_OPEN = false
	else
		hs.execute('open /Applications/Amethyst.app')
		AMETHYST_OPEN = true
	end
end
hyper:bind({'shift', 'cmd'}, ';', toggleAmethyst)

-- init grid
grid.destroy()
grid.init()

-- -- Toggle full screen
-- hs.hotkey.bind(HYPER, 'u', function()
-- 	hs.window.focusedWindow():toggleFullScreen()
-- end)

-- -- toggle full size
-- local frameCache = {}
-- function toggleWindowMaximized()
-- 	local win = hs.window.focusedWindow()
-- 	if frameCache[win:id()] then
-- 		win:setFrame(frameCache[win:id()])
-- 		frameCache[win:id()] = nil
-- 	else
-- 		frameCache[win:id()] = win:frame()
-- 		win:maximize()
-- 	end
-- end
-- hyper:bind({}, 'u', toggleWindowMaximized)


--[[
KEYBOARD TO MOUSE EVENTS
]]--
leftClickDown = function (  )
	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, hs.mouse.getAbsolutePosition()):post()
end

leftClickUp = function (  )
	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, hs.mouse.getAbsolutePosition()):post()
end

rightClickDown = function (  )
	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.rightMouseDown, hs.mouse.getAbsolutePosition()):post()
end

rightClickUp = function (  )
	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.rightMouseUp, hs.mouse.getAbsolutePosition()):post()
end

volumeMuteDown = function (  )
	hs.eventtap.event.newSystemKeyEvent('MUTE', true):post()
end

volumeMuteUp = function (  )
	hs.eventtap.event.newSystemKeyEvent('MUTE', false):post()
end

volumeDownDown = function (  )
	hs.eventtap.event.newSystemKeyEvent('SOUND_DOWN', true):post()
end

volumeDownUp = function (  )
	hs.eventtap.event.newSystemKeyEvent('SOUND_DOWN', false):post()
end

volumeUpDown = function (  )
	hs.eventtap.event.newSystemKeyEvent('SOUND_UP', true):post()
end

volumeUpUp = function (  )
	hs.eventtap.event.newSystemKeyEvent('SOUND_UP', false):post()
end

brightnessUpDown = function (  )
	hs.eventtap.event.newSystemKeyEvent('BRIGHTNESS_UP', true):post()
end

brightnessUpUp = function (  )
	hs.eventtap.event.newSystemKeyEvent('BRIGHTNESS_UP', false):post()
end

brightnessDownDown = function (  )
	hs.eventtap.event.newSystemKeyEvent('BRIGHTNESS_DOWN', true):post()
end

brightnessDownUp = function (  )
	hs.eventtap.event.newSystemKeyEvent('BRIGHTNESS_DOWN', false):post()
end


f1 = hs.hotkey.bind({}, 'F1', leftClickDown, leftClickUp)
f2 = hs.hotkey.bind({}, 'F2', rightClickDown, rightClickUp)
f5 = hs.hotkey.bind({}, 'F5', brightnessDownDown, brightnessDownUp)
f6 = hs.hotkey.bind({}, 'F6', brightnessUpDown, brightnessUpUp)
f10 = hs.hotkey.bind({}, 'F10', volumeMuteDown, volumeMuteUp)
f11 = hs.hotkey.bind({}, 'F11', volumeDownDown, volumeDownUp)
f12 = hs.hotkey.bind({}, 'F12', volumeUpDown, volumeUpUp)
f13 = hs.hotkey.bind({}, 'F13', volumeMuteDown, volumeMuteUp)
f14 = hs.hotkey.bind({}, 'F14', volumeDownDown, volumeDownUp)
f15 = hs.hotkey.bind({}, 'F15', volumeUpDown, volumeUpUp)

tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
	print(hs.inspect(event:getRawEventData()))
end)
tap:start()


-- [[ AUTO RELOAD CONFIG ]]
-- auto-reload when ~/.hammerspoon/*.lua is saved
function reloadConfig(files)
	doReload = false
	for _,file in pairs(files) do
		if file:sub(-4) == '.lua' then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

-- reload shortcut
-- hyper:bind({'cmd', 'shift'}, '\\', function()
-- 	hs.reload()
-- end)


--[[ KEYBOARD ONLY EXPOSE ]]
-- keyboard-only expose
hs.expose.ui.textColor = {1,1,1}
hs.expose.ui.fontName = 'Helvetica'
hs.expose.ui.textSize = 40 -- in screen points
hs.expose.ui.highlightColor = {0,0,0,.8} -- highlight color for candidate windows
hs.expose.ui.backgroundColor = {0,0,0,.8}
hs.expose.ui.closeModeModifier = 'shift' -- "close mode" engaged while pressed (or 'cmd','ctrl','alt')
hs.expose.ui.closeModeBackgroundColor = {0.7,0.1,0.1,.8} -- background color while "close mode" is engaged
hs.expose.ui.minimizeModeModifier = 'alt' -- "minimize mode" engaged while pressed
hs.expose.ui.minimizeModeBackgroundColor = {0.1,0.2,0.3,.8} -- background color while "minimize mode" is engaged
hs.expose.ui.onlyActiveApplication = false -- only show windows of the active application
hs.expose.ui.includeNonVisible = true -- include minimized and hidden windows
hs.expose.ui.nonVisibleStripBackgroundColor = {0,0,0,.8} -- contains hints for non-visible windows
-- hs.expose.ui.nonVisibleStripPosition = 'bottom' -- set it to your Dock position ('bottom', 'left' or 'right')
hs.expose.ui.nonVisibleStripWidth = 0.15 -- 0..0.5, width of the strip relative to the screen
hs.expose.ui.includeOtherSpaces = true -- include windows in other Mission Control Spaces
hs.expose.ui.otherSpacesStripBackgroundColor = {0,0,0,.8}
hs.expose.ui.otherSpacesStripPosition = 'top'
hs.expose.ui.otherSpacesStripWidth = 0.15
hs.expose.ui.showTitles = true -- show window titles
hs.expose.ui.showThumbnails = true -- show window thumbnails
hs.expose.ui.thumbnailAlpha = 1 -- 0..1, opacity for thumbnails
hs.expose.ui.highlightThumbnailAlpha = 1 -- 0..1, opacity for thumbnails of candidate windows
hs.expose.ui.highlightThumbnailStrokeWidth = 8 -- thumbnail frame thickness for candidate windows
hs.expose.ui.maxHintLetters = 2 -- if necessary, hints longer than this will be disambiguated with digits
hs.expose.ui.fitWindowsMaxIterations = 30 -- lower is faster, but higher chance of overlapping thumbnails
hs.expose.ui.fitWindowsInBackground = false -- improves responsivenss, but can affect the rest of the config
local expose = hs.expose.new()
hs.hotkey.bind({'alt'},'tab', function()
	expose:toggleShow()
end)


-- [[ CONFIG WATCHER ]]
-- hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

-- show reload config message
hs.alert.show('Config reloaded!')
