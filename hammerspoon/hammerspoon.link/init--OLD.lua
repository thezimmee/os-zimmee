--[[
@TODOs:
	- create window switcher with hs.window.switcher
	- create bindings for precise window resizing and movement
	- create layouts
		- "type" of windows get placed on certain spots or screens (i.e., important apps get placed in specific spots while others get piled away)
		- ability to save layouts?
	- create app "tabs" for multiple instances of an app?
--]]

-- show reload config message
hs.alert.show("Config reloading...")


local config = dofile('config.lua')

-- modifiers
local HYPER = config.hyper
local HYPER_CMD = config.hyper_cmd
local HYPER_SHIFT = config.hyper_shift
local HYPER_CMD_SHIFT = config.hyper_cmd_shift

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

--[[
HYPER TEST
]]--
-- HYPER+L: Open news.google.com in the default browser
lfun = function()
	news = "app = Application.currentApplication(); app.includeStandardAdditions = true; app.doShellScript('open http://news.google.com')"
	hs.osascript.javascript(news)
	hyper.triggered = true
end
hyper:bind('', 'l', nil, lfun)

-- HYPER+E: Act like ⌃e and move to end of line.
efun = function()
	hs.eventtap.keyStroke({'⌃'}, 'e')
	hyper.triggered = true
end
k:bind({}, 'e', nil, efun)

-- HYPER+A: Act like ⌃a and move to beginning of line.
afun = function()
	hs.eventtap.keyStroke({'⌃'}, 'a')
	hyper.triggered = true
end
hyper:bind({}, 'a', nil, afun)

--[[
GLOBAL BINDINGS
--]]
-- toggle window managers
local function toggleWindowManager( mode )
	if mode then
		WINDOW_MODE = mode
	else
		WINDOW_MODE = utils.toggler( WINDOW_MODES, WINDOW_MODE )
	end
	if WINDOW_MODE == 'hs' then
		-- hs.execute('brew services stop kwm', true)
		hs.execute('killall Amethyst')
		grid.init()
	elseif WINDOW_MODE == 'amethyst' then
		-- hs.execute('brew services stop kwm', true)
		grid.destroy()
		hs.execute('open /Applications/Amethyst.app')
	-- elseif WINDOW_MODE == 'kwm' then
	-- 	grid.destroy()
	-- 	hs.execute('killall Amethyst')
	-- 	hs.execute('brew services start kwm', true)
	end
	hs.alert.show('Switched to: ' .. WINDOW_MODE .. ' mode.')
end
hs.hotkey.bind(HYPER_CMD_SHIFT, ';', toggleWindowManager)
hs.hotkey.bind(HYPER_CMD_SHIFT, 'i', function (  )
	hs.alert.show(WINDOW_MODE .. ' mode')
end)
grid.destroy()
grid.init()
-- toggleWindowManager( 'hs' )

-- hs.hotkey.bind(HYPER_CMD_SHIFT, ';', function (  )
-- 	local kwm_enabled = hs.execute(config.kwmc .. ' query tiling mode')
-- 	if kwm_enabled ~= 'Connection failed!\n' then
-- 		hs.execute('brew services stop kwm', true)
-- 		hs.alert.show('Switched to amethyst')
-- 	else
-- 		hs.execute('brew services start kwm', true)
-- 		hs.alert.show('Switched to kwm')
-- 	end
-- 	hs.eventtap.keyStroke(HYPER_CMD, '.')
-- end)
-- hs.hotkey.bind(HYPER_SHIFT, '\\', function()
-- 	local tiling_mode = utils.trimString(hs.execute(config.kwmc .. ' query tiling mode'))
-- 	hs.alert.show('Tiling mode: ' .. tiling_mode .. '\nMovement: ' .. config.movementThreshold)
-- end)

-- --[[
-- KEYBOARD TO MOUSE EVENTS
-- ]]--
-- local function leftMouseClick()
-- 	local mousePosition = hs.mouse.getAbsolutePosition()
-- 	local types = hs.eventtap.event.types
-- 	hs.eventtap.event.newMouseEvent(types.leftMouseDown, mousePosition):post()
-- 	hs.eventtap.event.newMouseEvent(types.leftMouseUp, mousePosition):post()
-- end
-- local function rightMouseClick()
-- 	local mousePosition = hs.mouse.getAbsolutePosition()
-- 	local types = hs.eventtap.event.types
-- 	hs.eventtap.event.newMouseEvent(types.rightMouseDown, mousePosition):post()
-- 	hs.eventtap.event.newMouseEvent(types.rightMouseUp, mousePosition):post()
-- end
-- hs.hotkey.bind(nil, 'f1', nil, leftMouseClick, nil, nil)
-- hs.hotkey.bind(nil, 'f2', nil, rightMouseClick, nil, nil)

-- auto-reload when ~/.hammerspoon/*.lua is saved
function reloadConfig(files)
	doReload = false
	for _,file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

-- reload shortcut
hs.hotkey.bind(HYPER_CMD_SHIFT, '\\', function()
	hs.reload()
end)


--[[
	WINDOW RESIZING
--]]
-- -- resize to left half
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()
-- 	local screen = win:screen()
-- 	local max = screen:frame()

-- 	f.x = max.x
-- 	f.y = max.y
-- 	f.w = max.w / 2
-- 	f.h = max.h
-- 	win:setFrame(f)
-- end)

-- -- resize to right half
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()
-- 	local screen = win:screen()
-- 	local max = screen:frame()

-- 	f.x = max.x + (max.w / 2)
-- 	f.y = max.y
-- 	f.w = max.w / 2
-- 	f.h = max.h
-- 	win:setFrame(f)
-- end)

-- -- resize to bottom half
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()
-- 	local screen = win:screen()
-- 	local max = screen:frame()

-- 	f.x = max.x
-- 	f.y = max.y + (max.h / 2)
-- 	f.w = max.w
-- 	f.h = max.h / 2
-- 	win:setFrame(f)
-- end)

-- -- resize to top half
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()
-- 	local screen = win:screen()
-- 	local max = screen:frame()

-- 	f.x = max.x
-- 	f.y = max.y
-- 	f.w = max.w
-- 	f.h = max.h / 2
-- 	win:setFrame(f)
-- end)



--[[
	WINDOW MOVEMENT
--]]
-- -- move window up-left
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Y", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x - movementThreshold
-- 	f.y = f.y - movementThreshold
-- 	win:setFrame(f)
-- end)

-- -- move window up
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "K", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.y = f.y - movementThreshold
-- 	win:setFrame(f)
-- end)

-- -- move window up-right
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "U", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x + movementThreshold
-- 	f.y = f.y - movementThreshold
-- 	win:setFrame(f)
-- end)

-- -- move window left
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x - movementThreshold
-- 	win:setFrame(f)
-- end)

-- -- move window right
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "L", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x + movementThreshold
-- 	win:setFrame(f)
-- end)

-- -- move window down-left
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "B", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x - movementThreshold
-- 	f.y = f.y + movementThreshold
-- 	win:setFrame(f)
-- end)

-- -- move window down
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "J", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.y = f.y + movementThreshold
-- 	win:setFrame(f)
-- end)

-- -- move window down-right
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "N", function()
-- 	local win = hs.window.focusedWindow()
-- 	local f = win:frame()

-- 	f.x = f.x + movementThreshold
-- 	f.y = f.y + movementThreshold
-- 	win:setFrame(f)
-- end)

-- hs.hotkey.bind("ctrl", "/", function (  )
-- 	os.exec()
-- end)

--[[
APP TABS
--]]
-- hs.tabs.enableForApp('Sublime Text')
-- hs.hotkey.bind(HYPER_SHIFT, '.', function (  )
-- 	hs.alert(hs.tabs.tabWindows('Sublime Text'))
-- end)
-- local switcher = hs.window.switcher.new()
-- hs.hotkey.bind(HYPER, 'g', function (  )
-- 	switcher:next()
-- end)



--[[
KEYBOARD ONLY EXPOSE
--]]
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
-- hs.hotkey.bind(HYPER, 'i', toggleWindowMaximized)


-- watcher for hammerspoon config changes
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
