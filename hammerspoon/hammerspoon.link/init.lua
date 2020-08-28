-- local WindowGrid = hs.loadSpoon('WindowGrid')
-- WindowGrid:bindHotkeys(hs.hotkey.new('ctrl', 'o'))
-- WindowGrid:start()

-- [[ START ]] Setup.
local config = require 'config'
-- local grid = require 'grid'
-- [[ END ]]

-- [[ START ]] Load spoons.
hs.loadSpoon('WindowScreenLeftAndRight')
spoon.WindowScreenLeftAndRight:bindHotkeys({
  screen_left = { config.hyper_shift, "U" },
  screen_right= { config.hyper_shift, "O" },
})

hs.loadSpoon('Emojis')
spoon.Emojis:bindHotkeys({
  toggle = { config.hyper_cmd, "'" }
})

-- hs.loadSpoon('WindowGrid')
-- spoon.WindowGrid:bindHotkeys({
--   show_grid = { config.hyper, "O" }
-- })
-- spoon.WindowGrid:start()
-- [[ END ]]

-- [[ START ]] Window grid.
-- grid.destroy()
-- grid.init()
-- [[ END ]]

-- [[ START ]] Launcher.
-- hs.loadSpoon('Seal')
-- spoon.Seal:bindHotkeys({
--   toggle = { config.hyper, "w" },
--   show = { config.hyper, "w" },
-- })
-- spoon.Seal:loadPlugins({"apps", "calc", "screencapture"})
-- spoon.Seal:start()
-- [[ END ]]

-- [[ START ]] Switcher.
-- -- set up your windowfilter
-- switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
-- switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}) -- include minimized/hidden windows, current Space only
-- switcher_browsers = hs.window.switcher.new{'Sublime Text', 'Brave Browser', 'iTerm2'} -- specialized switcher for your dozens of browser windows :)
-- switcher_browsers.ui.highlightColor = {0, 0, 0, 0.2}
-- switcher_browsers.ui.showTitles = false
-- switcher_browsers.ui.thumbnailSize = 64

-- -- bind to hotkeys; WARNING: at least one modifier key is required!
-- hs.hotkey.bind('alt','tab',null,function()switcher_browsers:next()end)
-- hs.hotkey.bind('alt-shift','tab',null,function()switcher_browsers:previous()end)

-- -- alternatively, call .nextWindow() or .previousWindow() directly (same as hs.window.switcher.new():next())
-- -- hs.hotkey.bind('alt','tab','Next window',hs.window.switcher.nextWindow)
-- -- you can also bind to `repeatFn` for faster traversing
-- -- hs.hotkey.bind('alt-shift','tab','Prev window',hs.window.switcher.previousWindow,nil,hs.window.switcher.previousWindow)
-- [[ END ]]


-- [[ START ]] Reload config.
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
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.hotkey.bind(config.hyper_cmd_shift, '\\', function()
  hs.reload()
end)
-- [[ END ]]


-- [[ START ]] Show reload config message.
hs.alert.show('Config reloaded!')
-- [[ END ]]
