--[[
@TODOs:
	- refactor:
		- refactor grid to functions (bindings are customizable)
		- add all key bindings in init (or key bindings module)
	- create bindings for precise window resizing and movement
--]]


-- [[ START ]] Setup.
-- load config
local config = dofile('config.lua')

-- helpers
local utils = dofile('helpers/utils.lua')

-- components
local grid = dofile('grid.lua')
local mouse = dofile('click-drag.lua')

-- locals
local WINDOW_MODES = {'hs', 'amethyst'}
local WINDOW_MODE = 'hs'
-- [[ END ]]


-- [[ START ]] Window manager.
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
hs.hotkey.bind(config.hyper_cmd_shift, ';', toggleAmethyst)
-- [[ END ]]


-- [[ START ]] Window grid.
grid.destroy()
grid.init()
-- [[ END ]]


-- [[ START ]] Keyboard mouse clicks.
leftClickDown = function (  )
	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, hs.mouse.getAbsolutePosition()):post()
end

leftClickDrag = function (  )
	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDragged, hs.mouse.getAbsolutePosition()):post()
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


f1 = mouse.bind({}, 'f1', 1)
f2 = hs.hotkey.bind({}, 'f2', rightClickDown, rightClickUp)

tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
	print(hs.inspect(event:getRawEventData()))
end)
tap:start()
-- [[ END ]]


-- [[ START ]] Reload config.
hs.hotkey.bind(config.hyper_cmd_shift, '\\', function()
	hs.reload()
end)
-- [[ END ]]


-- [[ START ]] Keyboard only window switcher.
-- keyboard-only expose
-- hs.expose.ui.textColor = {1,1,1}
-- hs.expose.ui.fontName = 'Helvetica'
-- hs.expose.ui.textSize = 40 -- in screen points
-- hs.expose.ui.highlightColor = {0,0,0,.8} -- highlight color for candidate windows
-- hs.expose.ui.backgroundColor = {0,0,0,.8}
-- hs.expose.ui.closeModeModifier = 'shift' -- "close mode" engaged while pressed (or 'cmd','ctrl','alt')
-- hs.expose.ui.closeModeBackgroundColor = {0.7,0.1,0.1,.8} -- background color while "close mode" is engaged
-- hs.expose.ui.minimizeModeModifier = 'alt' -- "minimize mode" engaged while pressed
-- hs.expose.ui.minimizeModeBackgroundColor = {0.1,0.2,0.3,.8} -- background color while "minimize mode" is engaged
-- hs.expose.ui.onlyActiveApplication = false -- only show windows of the active application
-- hs.expose.ui.includeNonVisible = true -- include minimized and hidden windows
-- hs.expose.ui.nonVisibleStripBackgroundColor = {0,0,0,.8} -- contains hints for non-visible windows
-- -- hs.expose.ui.nonVisibleStripPosition = 'bottom' -- set it to your Dock position ('bottom', 'left' or 'right')
-- hs.expose.ui.nonVisibleStripWidth = 0.15 -- 0..0.5, width of the strip relative to the screen
-- hs.expose.ui.includeOtherSpaces = true -- include windows in other Mission Control Spaces
-- hs.expose.ui.otherSpacesStripBackgroundColor = {0,0,0,.8}
-- hs.expose.ui.otherSpacesStripPosition = 'top'
-- hs.expose.ui.otherSpacesStripWidth = 0.15
-- hs.expose.ui.showTitles = true -- show window titles
-- hs.expose.ui.showThumbnails = true -- show window thumbnails
-- hs.expose.ui.thumbnailAlpha = 1 -- 0..1, opacity for thumbnails
-- hs.expose.ui.highlightThumbnailAlpha = 1 -- 0..1, opacity for thumbnails of candidate windows
-- hs.expose.ui.highlightThumbnailStrokeWidth = 8 -- thumbnail frame thickness for candidate windows
-- hs.expose.ui.maxHintLetters = 2 -- if necessary, hints longer than this will be disambiguated with digits
-- hs.expose.ui.fitWindowsMaxIterations = 30 -- lower is faster, but higher chance of overlapping thumbnails
-- hs.expose.ui.fitWindowsInBackground = false -- improves responsivenss, but can affect the rest of the config
-- local expose = hs.expose.new()
-- hs.hotkey.bind({'alt'},'tab', function()
-- 	expose:toggleShow()
-- end)
-- [[ END ]]


-- [[ START ]] Show reload config message.
hs.alert.show('Config reloaded!')
-- [[ END ]]
