local interface = {}

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

local function initialize(args)
  local theme_name = args.theme

  awful.util.terminal = "alacritty"
  awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
  awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    --awful.layout.suit.tile.left,
    --lain.layout.centerwork
  }

  -- Load the theme requested
  require(string.format("themes.%s.setup", theme_name))
  
  -- Abstract setting up the wallpaper
  local set_wallpaper = function(s)
    -- Set wallpaper
    if beautiful.wallpaper then
      local wallpaper =  beautiful.wallpaper
      local background = beautiful.background
       -- If wallpaper is a function, call it with the screen
      if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
      end
      gears.wallpaper.maximized(wallpaper, s)
    end
  end

  -- Stuff to do when a screen is connected
  awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
  end)

  -- Stuff to do when the resolution changes
  screen.connect_signal("property::geometry", function(s)
    set_wallpaper(s)
  end)
end

setmetatable(interface, { __call = function(_, args) return initialize(args) end })

return interface
