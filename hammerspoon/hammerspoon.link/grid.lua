--[[
	GRID (http://lowne.github.io/hammerspoon-extensions/)
--]]


-- [[ START ]] Locals setup.
local config = dofile('config.lua')
local grid = {}
local hotkeys = {}
-- [[ END ]]


-- [[ START ]] Add keyboard bindings.
local function addBindings(  )
	-- toggle maximize
	local frameCache = {}
	hs.hotkey.bind(config.hyper, 'i', function ()
		local win = hs.window.focusedWindow()
		if frameCache[win:id()] then
			win:setFrame(frameCache[win:id()])
			frameCache[win:id()] = nil
		else
			frameCache[win:id()] = win:frame()
			win:maximize()
		end
	end)
	-- move windows to grid
	hotkeys['hyper_shift_l'] = hs.hotkey.bind(config.hyper_shift, 'l', function()
		local win = hs.window.focusedWindow()
		hs.grid.pushWindowRight(win)
	end)
	hotkeys['hyper_shift_j'] = hs.hotkey.bind(config.hyper_shift, 'j', function()
		local win = hs.window.focusedWindow()
		hs.grid.pushWindowLeft(win)
	end)
	hotkeys['hyper_shift_i'] = hs.hotkey.bind(config.hyper_shift, 'i', function()
		local win = hs.window.focusedWindow()
		hs.grid.pushWindowUp(win)
	end)
	hotkeys['hyper_shift_k'] = hs.hotkey.bind(config.hyper_shift, 'k', function()
		local win = hs.window.focusedWindow()
		hs.grid.pushWindowDown(win)
	end)

	-- resize windows to grid
	hotkeys['hyper_cmd_j'] = hs.hotkey.bind(config.hyper_cmd, 'j', function()
		local win = hs.window.focusedWindow()
		hs.grid.resizeWindowThinner(win)
	end)
	hotkeys['hyper_cmd_l'] = hs.hotkey.bind(config.hyper_cmd, 'l', function()
		local win = hs.window.focusedWindow()
		hs.grid.resizeWindowWider(win)
	end)
	hotkeys['hyper_cmd_k'] = hs.hotkey.bind(config.hyper_cmd, 'k', function()
		local win = hs.window.focusedWindow()
		hs.grid.resizeWindowTaller(win)
	end)
	hotkeys['hyper_cmd_i'] = hs.hotkey.bind(config.hyper_cmd, 'i', function()
		local win = hs.window.focusedWindow()
		hs.grid.resizeWindowShorter(win)
	end)

	-- resize windows incrementally
	hotkeys['hyper_cmd_shift_j'] = hs.hotkey.bind(config.hyper_cmd_shift, 'j', function()
		local win = hs.window.focusedWindow()
		local f = win:frame()

		f.w = f.w - config.movementThreshold
		win:setFrame(f)
	end)
	hotkeys['hyper_cmd_shift_l'] = hs.hotkey.bind(config.hyper_cmd_shift, 'l', function()
		local win = hs.window.focusedWindow()
		local f = win:frame()

		f.w = f.w + config.movementThreshold
		win:setFrame(f)
	end)

	-- focus windows
	hotkeys['hyper_l'] = hs.hotkey.bind(config.hyper, 'l', function()
		hs.window.focusedWindow():focusWindowEast()
	end)
	hotkeys['hyper_j'] = hs.hotkey.bind(config.hyper, 'j', function()
		hs.window.focusedWindow():focusWindowWest()
	end)
	-- hotkeys['hyper_i'] = hs.hotkey.bind(config.hyper, 'i', function()
	-- 	hs.window.focusedWindow():focusWindowNorth()
	-- end)
	-- hotkeys['hyper_k'] = hs.hotkey.bind(config.hyper, 'k', function()
	-- 	hs.window.focusedWindow():focusWindowSouth()
	-- end)
	-- center window
	hotkeys['hyper_;'] = hs.hotkey.bind(config.hyper, '.', function()
		hs.window.focusedWindow():centerOnScreen()
	end)

	-- open grid manager
	hotkeys['hyper_o'] = hs.hotkey.bind(config.hyper, 'o', hs.grid.show)
end
-- [[ END ]]


-- [[ START ]] Remove bindings.
local function removeBindings(  )
	for i = 1, #hotkeys do
		hotkeys[i]:delete()
	end
end
-- [[ END ]]


-- [[ START ]] Initialize grid.
local function init(  )
	-- define window grid
	hs.grid.GRIDWIDTH = config.grid.width
	hs.grid.GRIDHEIGHT = config.grid.height
	hs.grid.MARGINX = config.grid.marginx
	hs.grid.MARGINY = config.grid.marginy
	hs.grid.ui.showExtraKeys = true

	addBindings()
end
-- [[ END ]]


-- [[ START ]] Destroy grid.
local function destroy(  )
	removeBindings()
end
-- [[ END ]]


-- [[ START ]] Return object.
grid.init = init
grid.destroy = destroy
return grid
-- [[ END ]]
