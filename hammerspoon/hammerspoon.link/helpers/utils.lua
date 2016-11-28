local utils = {}

-- trim string
local function trimString( string )
	return (string:gsub("^%s*(.-)%s*$", "%1"))
end

local function toggler( togglerArray, toggle )
	for i = 1, #togglerArray do
		if togglerArray[i] == toggle then
			if i == #togglerArray then
				toggle = togglerArray[1]
			else
				toggle = togglerArray[i + 1]
			end
			break
		end
	end
	return toggle
end

utils.trimString = trimString
utils.toggler = toggler

return utils