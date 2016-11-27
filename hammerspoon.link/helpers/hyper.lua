--[[
HYPER KEY
[Credit to @lodestone](https://github.com/lodestone/hyper-hacks/blob/master/hammerspoon/init.lua)
]]--
-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, 'F17')

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
	k.triggered = true
	k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
	k.triggered = false
	k:exit()
	-- if not k.triggered then
	-- 	hs.eventtap.keyStroke({}, 'ESCAPE')
	-- end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)

return k
