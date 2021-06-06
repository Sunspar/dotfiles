------------------------------------------------------------------------------------------
-- Standard Library
------------------------------------------------------------------------------------------
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local awful         = require("awful")
                      require("awful.autofocus")
local beautiful     = require("beautiful")
local dpi           = require("beautiful.xresources").apply_dpi
local freedesktop   = require("freedesktop")
local gears         = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local lain          = require("lain")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local naughty       = require("naughty")
local wibox         = require("wibox")

------------------------------------------------------------------------------------------
-- Error Handling
------------------------------------------------------------------------------------------
-- If we couldnt load our config at all, trigger a notificaton with /why/
if awesome.startup_errors then
  naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors
  })
end

-- If we have runtime errors during system use, let's render them with notification popups.
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    if in_error then return end
    in_error = true

    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = tostring(err)
    })

    in_error = false
  end)
end

------------------------------------------------------------------------------------------
-- Autostart
------------------------------------------------------------------------------------------
-- This function will run once every time Awesome is started. This INCLUDES refreshing the config
local function run_once(cmd_arr)
  for _, cmd in ipairs(cmd_arr) do
    awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
  end
end

run_once({ "picom", "zsh ~/.screenlayout/s.sh" })

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]

-- Load the main interface
require("interface")({
  theme = "nord"
})

xrdb = require("beautiful.xresources").get_current_theme()

-- Load dashboard and the assigned widget tree
require("widgets.dashboard")({
  {
    require("widgets.dashboard.components.bookmarks")({
      items = {
        { "home", "nautilus /home/sunspar", xrdb.color1, xrdb.color9 },
        { "workspace", "nautilus /home/sunspar/workspace/", xrdb.color2, xrdb.color10 },
        { "htop", "alacritty -e htop", xrdb.color3, xrdb.color11 },
        { "emacs", "emacs", xrdb.color4, xrdb.color12 }
      },
      width  = dpi(100),
      height = dpi(180)
    }),
    require("widgets.dashboard.components.user")({
        picture = "/home/sunspar/quinn.jpg",
        width = dpi(200),
        height = dpi(250)
    }),
  },
  {
    require("widgets.dashboard.components.disk_usage")({
        width = dpi(250),
        height = dpi(200),
    })
  }
})

local bindings = require("bindings")
awful.util.taglist_buttons = bindings.taglist_button_bindings

awful.util.tasklist_buttons = my_table.join(
  awful.button({ }, 1, function (c)
      if c == client.focus then
        c.minimized = true
      else
        c.minimized = false
        if not c:isvisible() and c.first_tag then
          c.first_tag:view_only()
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
      end
  end),
  awful.button({ }, 2, function (c) c:kill() end),
  awful.button({ }, 3, function ()
      local instance = nil

      return function ()
        if instance and instance.wibox.visible then
          instance:hide()
          instance = nil
        else
          instance = awful.menu.clients({theme = {width = dpi(250)}})
        end
      end
  end),
  awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
  awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

local terminal = "kitty"
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or dpi(16),
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
})

-- Set keybindings so we can interact with the system.
root.buttons(bindings.root_mouse_bindings)
root.keys(bindings.root_keyboard_bindings)

-- Client styling and default placement preferences.
awful.rules.rules = require("client-rules")

-- Load signals and anything else that needs to just be executed and present
require("client-signals")
require("screen-signals")

-- Evil provides system triggers and periodic updates for widgets that require poking into the system for information to display.
require("evil")
