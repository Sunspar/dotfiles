------------------------------------------------------------------------------------------
-- Standard Library
------------------------------------------------------------------------------------------
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local dpi           = require("beautiful.xresources").apply_dpi

local mod  = "Mod4"
local alt  = "Mod1"
local ctrl = "Control"
local shft = "Shift"

-- I prefer this syntax better, since the functions are usually multiple lines whereas the help
-- text is usually a one liner. This just wraps the awful.key and swaps the last two arguments.
local function bindk(modifiers, key, opts, func)
    options = {group = opts[1], description = opts[2]}
    return awful.key(modifiers, key, func, options)
end

local bindm = awful.button

------------------------------------------------------------------------------------------
-- Root Mouse Bindings
------------------------------------------------------------------------------------------
local root_mouse_bindings = gears.table.join(
    bindm({ }, 3, function () awful.util.mymainmenu:toggle() end)
)

------------------------------------------------------------------------------------------
-- Global Keyboard Bindings
------------------------------------------------------------------------------------------
local root_keyboard_bindings = gears.table.join(

    -- Launch program shortcuts
    bindk({ mod }, "Return", {"launchers", "Open a terminal"}, function() awful.spawn("kitty") end),

    -- Action hotkeys
    bindk({ mod }, "r", {"hotkeys", "Restart awesomewm"}, awesome.restart),
    bindk({ mod, ctrl }, "q", {"hotkeys", "Logout (quit awesomewm)"}, awesome.quit),
    bindk({ mod }, "/", {"hotkeys", "show help message"}, hotkeys_popup.show_help),
    bindk({ mod }, "space", {"hotkeys", "rofi app launcher"}, function() os.execute("rofi -show combi") end),
    bindk({mod }, "e", {"hotkeys", "file manager"}, function() os.execute("thunar") end),
    bindk({ alt }, "p", {"hotkeys", "take a screenshot"}, function() os.execute("screenshot") end),
    bindk({ ctrl, alt }, "l", {"hotkeys", "lock screen"}, function () os.execute(scrlocker) end),
    bindk( { mod }, "Escape", {"hotkeys", "Show dashboard"}, show_dashboard),
    -- Tag browsing
    bindk({ ctrl }, "h", {"tags", "view prev"}, awful.tag.viewprev),
    bindk({ ctrl }, "l", {"tags", "view next"}, awful.tag.viewnext),
    bindk({ ctrl }, "Escape", {"tags", "go back"}, awful.tag.history.restore),

    -- Client focus management
    bindk({ mod }, "h", {"clients", "focus left"}, function ()
        awful.client.focus.global_bydirection("left")
        if client.focus then client.focus:raise() end
    end),
    bindk({ mod }, "j", {"clients", "focus down"}, function()
        awful.client.focus.global_bydirection("down")
        if client.focus then client.focus:raise() end
    end),
    bindk({ mod }, "k", {"clients", "focus up"}, function()
        awful.client.focus.global_bydirection("up")
        if client.focus then client.focus:raise() end
    end),
    bindk({ mod }, "l", {"clients", "focus right"}, function()
        awful.client.focus.global_bydirection("right")
        if client.focus then client.focus:raise() end
    end),

    -- Layout manipulation
    awful.key({ mod, shft }, "j",
        function () awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client"  }),
    awful.key({ mod, shft }, "k",
        function () awful.client.swap.byidx( -1)    end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ mod, ctrl }, "j",
        function () awful.screen.focus_relative( 1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ mod, ctrl }, "k",
        function () awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ mod,           }, "Tab",
        function ()
            if cycle_prev then
                awful.client.focus.history.previous()
            else
                awful.client.focus.byidx(-1)
            end
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "cycle with previous/go back", group = "client"}),
    awful.key({ mod, shft   }, "Tab",
        function ()
            if cycle_prev then
                awful.client.focus.byidx(1)
                if client.focus then
                    client.focus:raise()
                end
            end
        end,
        {description = "go forth", group = "client"}),

    -- Show/Hide Wibox
    awful.key({ mod }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        { description = "toggle wibox", group = "awesome" }),

    bindk({ mod }, "l", {"layout", "increase master with factor"}, function() awful.tag.incmwfact(0.05) end),
    bindk({ mod }, "h", {"layout", "decrease master with factor"}, function() awful.tag.incmwfact(-0.05) end),

    -- awful.key({ mod, shft   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    --           {description = "increase the number of master clients", group = "layout"}),
    -- awful.key({ mod, shft   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    --           {description = "decrease the number of master clients", group = "layout"}),
    -- awful.key({ mod, ctrl }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    --           {description = "increase the number of columns", group = "layout"}),
    -- awful.key({ mod, ctrl }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    --           {description = "decrease the number of columns", group = "layout"}),
    -- awful.key({ mod,           }, "space", function () awful.layout.inc( 1)                end,
    --           {description = "select next", group = "layout"}),
    -- awful.key({ mod, shft   }, "space", function () awful.layout.inc(-1)                end,
    --           {description = "select previous", group = "layout"}),

    awful.key({ mod, ctrl }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Dropdown application
    awful.key({ mod, }, "z", function () awful.screen.focused().quake:toggle() end,
              {description = "dropdown application", group = "launcher"}),

    -- Widgets popups
    awful.key({ alt, }, "c", function () if beautiful.cal then beautiful.cal.show(7) end end,
              {description = "show calendar", group = "widgets"}),
    awful.key({ alt, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
              {description = "show filesystem", group = "widgets"}),
    awful.key({ alt, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
              {description = "show weather", group = "widgets"}),

    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp", function () os.execute("xbacklight -inc 10") end,
              {description = "+10%", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown", function () os.execute("xbacklight -dec 10") end,
              {description = "-10%", group = "hotkeys"}),

    
    bindk({}, "XF86AudioMute", {"volume", "toggle mute"}, function()
        os.execute("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    end),
    bindk({}, "XF86AudioRaiseVolume", {"volume", "raise output volume"}, function()
        os.execute("pactl set-sink-volume @DEFAULT_SINK@ +5%")
    end),
    bindk({}, "XF86AudioLowerVolume", {"volume", "lower output volume"}, function()
        os.execute("pactl set-sink-volume @DEFAULT_SINK@ -5%")
    end),

    -- ALSA volume control
    awful.key({ alt }, "Up",
        function ()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume up", group = "hotkeys"}),
    awful.key({ alt }, "Down",
        function ()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume down", group = "hotkeys"}),
    awful.key({ alt }, "m",
        function ()
            os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "toggle mute", group = "hotkeys"}),
    awful.key({ alt, ctrl }, "m",
        function ()
            os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume 100%", group = "hotkeys"}),
    awful.key({ alt, ctrl }, "0",
        function ()
            os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume 0%", group = "hotkeys"}),

    -- Copy primary to clipboard (terminals to gtk)
    awful.key({ mod }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
              {description = "copy terminal to gtk", group = "hotkeys"}),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key({ mod }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
              {description = "copy gtk to terminal", group = "hotkeys"}),

    -- User programs
    --awful.key({ mod }, "q", function () awful.spawn(browser) end,
    --          {description = "run browser", group = "launcher"}),
    awful.key({ mod }, "a", function () awful.spawn(guieditor) end,
              {description = "run gui editor", group = "launcher"}),


    -- Prompt
    awful.key({ mod }, "r", function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ mod }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"})
    --]]
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    root_keyboard_bindings = gears.table.join(root_keyboard_bindings,
        -- View tag
        bindk({ mod }, "#" .. i + 9, {"tags", "view tag #"}, function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end),

        -- Toggle tag display.
        bindk({ mod, ctrl }, "#" .. i + 9, {"tags", "toggle tag #"}, function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end),

        -- Move client to tag.
        bindk({ mod, shft }, "#" .. i + 9, {"tags", "move focused client to tag #"}, function ()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end),

        -- Toggle tag on focused client.
        bindk({ mod, ctrl, shft }, "#" .. i + 9, {"tags", "Toggle focused client on tag #"}, function ()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end)
    )
end

------------------------------------------------------------------------------------------
-- Window-specific Keyboard Bindings
------------------------------------------------------------------------------------------
local client_keyboard_bindings = gears.table.join(
    bindk({ alt, shft }, "m", {"clients", "Magnify"}, lain.util.magnify_client),
    bindk({ mod }, "f", {"clients", "Toggle fullscreen"}, function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end),
    bindk({ mod }, "q", {"clients", "kill window"}, function(c) c:kill() end),
    --bindk({ alt }, )
    awful.key({ mod, ctrl }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ mod, ctrl }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ mod,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ mod,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ mod,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ mod,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "maximize", group = "client"})
)

------------------------------------------------------------------------------------------
-- Window-specific Mouse Bindings
------------------------------------------------------------------------------------------
local client_mouse_bindings = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ mod }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ mod }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

------------------------------------------------------------------------------------------
-- Taglist Button Bindings
------------------------------------------------------------------------------------------
local taglist_button_bindings = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ mod }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ mod }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

------------------------------------------------------------------------------------------
-- Exposed Interface
------------------------------------------------------------------------------------------
return {
  root_mouse_bindings      = root_mouse_bindings,
  root_keyboard_bindings   = root_keyboard_bindings,
  client_mouse_bindings    = client_mouse_bindings,
  client_keyboard_bindings = client_keyboard_bindings,
  taglist_button_bindings  = taglist_button_bindings
}
