-- modifiers
local HYPER = {"ctrl", "alt"}
local HYPER_CMD = {"ctrl", "alt", "cmd"}
local HYPER_SHIFT = {"ctrl", "alt", "shift"}
local HYPER_CMD_SHIFT = {"ctrl", "alt", "shift", "cmd"}

-- configuration variables
local movementThreshold = 10

-- define window grid
hs.grid.GRIDWIDTH = 10
hs.grid.GRIDHEIGHT = 4
hs.grid.MARGINX = 2
hs.grid.MARGINY = 2

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



--[[
HAMMERSPOON WINDOW GRID / TILING [http://lowne.github.io/hammerspoon-extensions/]
--]]
-- local function bind(mod,key,fn,msg,dur)
-- 	hs.hotkey.bind(mod,key,function()
-- 		fn() hs.alert(msg,dur or 2)
-- 	end)
-- end

-- -- set window(s) to grid
-- bind(HYPER, 'o', hs.grid.show)


--[[
KEYBOARD ONLY SWITCHER / EXPOSE
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
hs.expose.ui.nonVisibleStripWidth = 0.025 -- 0..0.5, width of the strip relative to the screen
hs.expose.ui.includeOtherSpaces = true -- include windows in other Mission Control Spaces
hs.expose.ui.otherSpacesStripBackgroundColor = {0,0,0,.8}
hs.expose.ui.otherSpacesStripPosition = 'top'
hs.expose.ui.otherSpacesStripWidth = 0.15
hs.expose.ui.showTitles = true -- show window titles
hs.expose.ui.showThumbnails = true -- show window thumbnails
hs.expose.ui.thumbnailAlpha = 0 -- 0..1, opacity for thumbnails
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

-- -- focus windows
-- hs.hotkey.bind(HYPER, 'k', function()
-- 	hs.window.focusedWindow():focusWindowEast()
-- end)
-- hs.hotkey.bind(HYPER, 'j', function()
-- 	hs.window.focusedWindow():focusWindowWest()
-- end)
-- hs.hotkey.bind(HYPER, 'h', function()
-- 	hs.window.focusedWindow():focusWindowNorth()
-- end)
-- hs.hotkey.bind(HYPER, 'l', function()
-- 	hs.window.focusedWindow():focusWindowSouth()
-- end)
-- -- center window
-- hs.hotkey.bind(HYPER, ';', function()
-- 	hs.window.focusedWindow():centerOnScreen()
-- end)

-- -- move windows to grid
-- hs.hotkey.bind(HYPER_SHIFT, 'k', function()
-- 	local win = hs.window.focusedWindow()
-- 	hs.grid.pushWindowRight(win)
-- end)
-- hs.hotkey.bind(HYPER_SHIFT, 'j', function()
-- 	local win = hs.window.focusedWindow()
-- 	hs.grid.pushWindowLeft(win)
-- end)
-- hs.hotkey.bind(HYPER_SHIFT, 'i', function()
-- 	local win = hs.window.focusedWindow()
-- 	hs.grid.pushWindowUp(win)
-- end)
-- hs.hotkey.bind(HYPER_SHIFT, 'm', function()
-- 	local win = hs.window.focusedWindow()
-- 	hs.grid.pushWindowDown(win)
-- end)

-- -- resize windows to grid
-- hs.hotkey.bind(HYPER_CMD, 'k', function()
-- 	local win = hs.window.focusedWindow()
-- 	hs.grid.resizeWindowWider(win)
-- end)
-- hs.hotkey.bind(HYPER_CMD, 'j', function()
-- 	local win = hs.window.focusedWindow()
-- 	hs.grid.resizeWindowThinner(win)
-- end)
-- hs.hotkey.bind(HYPER_CMD, 'i', function()
-- 	local win = hs.window.focusedWindow()
-- 	hs.grid.resizeWindowTaller(win)
-- end)
-- hs.hotkey.bind(HYPER_CMD, 'm', function()
-- 	local win = hs.window.focusedWindow()
-- 	hs.grid.resizeWindowShorter(win)
-- end)


-- watcher for hammerspoon config changes
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
-- show reload config message
hs.alert.show("Config loaded")