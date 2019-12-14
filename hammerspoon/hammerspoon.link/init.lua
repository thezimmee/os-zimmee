-- local WindowGrid = hs.loadSpoon('WindowGrid')
-- WindowGrid:bindHotkeys(hs.hotkey.new('ctrl', 'o'))
-- WindowGrid:start()

-- [[ START ]] Setup.
local config = require 'config'
local grid = require 'grid'
-- [[ END ]]

-- [[ START ]] Load spoons.
hs.loadSpoon('WindowScreenLeftAndRight')
spoon.WindowScreenLeftAndRight:bindHotkeys({
  screen_left = { config.hyper_shift, "U" },
  screen_right= { config.hyper_shift, "O" },
})

hs.loadSpoon('Emojis')
spoon.Emojis:bindHotkeys({
  toggle = { config.hyper, ";" }
})

-- hs.loadSpoon('WindowGrid')
-- spoon.WindowGrid:bindHotkeys({
--   show_grid = { config.hyper, "O" }
-- })
-- spoon.WindowGrid:start()
-- [[ END ]]

-- [[ START ]] Window grid.
grid.destroy()
grid.init()
-- [[ END ]]


-- [[ START ]] Reload config.
hs.hotkey.bind(config.hyper_cmd_shift, '\\', function()
  hs.reload()
end)
-- [[ END ]]


-- [[ START ]] Show reload config message.
hs.alert.show('Config reloaded!')
-- [[ END ]]
