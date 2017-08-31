--[[
	MOUSE CLICK AND DRAG.
	Credit to [https://stackoverflow.com/questions/45203657/macos-sierra-emulate-mouse-down-and-up] for help with mouse dragging.
]]--

local mouse = {}

local function addBinding( mods, key )
	now = hs.timer.secondsSinceEpoch

	evt = hs.eventtap
	evte = evt.event
	evtypes = evte.types
	evp=evte.properties

	drag_last = now(); drag_intv = 0.01 -- we only synth drags from time to time

	mp = {['x']=0, ['y']=0} -- mouse point. coords and last posted event
	l = hs.logger.new('keybmouse', 'debug')
	dmp = hs.inspect

	-- The event tap. Started with the keyboard click:
	handled = {evtypes.mouseMoved, evtypes.keyUp }
	handleDrag = evt.new(handled, function(e)

		if e:getType() == evtypes.keyUp then
			handleDrag:stop()
			postEvent(2)
			return nil -- otherwise the up seems not processed by the OS
		end

		mp['x']  = mp['x'] + e:getProperty(evp.mouseEventDeltaX)
		mp['y']  = mp['y'] + e:getProperty(evp.mouseEventDeltaY)

		-- giving the key up a chance:
		if now() - drag_last > drag_intv then
			-- l.d('pos', mp.x, 'dx', dx)
			postEvent(6) -- that sometimes makes dx negative in the log above
			drag_last = now()
		end
		return true -- important
	end)

	return hs.hotkey.bind(mods, key, function ( event )
		postEvent(1)
		handleDrag:start()
	end)
end

function postEvent(mode)
	-- 1: down, 2: up, 6: drag
	if mode == 1 or mode == 2 then
		local p = hs.mouse.getAbsolutePosition()
		mp['x'] = p.x
		mp['y'] = p.y
	end
	local e = hs.eventtap.event.newMouseEvent(mode, mp)
	if mode == 6 then cs = 0 else cs=1 end
	e:setProperty(evte.properties.mouseEventClickState, cs)
	e:post()
end

mouse.bind = addBinding

return mouse
