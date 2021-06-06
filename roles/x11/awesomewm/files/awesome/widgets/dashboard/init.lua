local dashboard = {}

-- Standard import stuff
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local naughty   = require("naughty")
local wibox     = require("wibox")
local xrdb      = require("beautiful.xresources").get_current_theme()

-- Dashboard overlay widget.
--
-- This widget provides a customizable dashboard/start screen that displays full screen.
-- We capture all input during the time the start screen is displayed to allow you to interact with it correctly.
--
--
-- Global Identifiers Provided
--
-- [Function] show_dashboard
--     The handler you can bind to in order to trigger showing the dashboard widget.
-- [Function] hide_dashboard
--     The handler exposed for things to be able to trigger hiding the dashboard widget.
local keygrabber

-- Appearances
local box_radius = dpi(12)
local box_gap = dpi(6)
local dashboard_bg = '#111111'
local dashboard_fg = '#FEFEFE'

local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- Quickly show or hide all the dashboard widgets across all screens.
local function set_visibility(v)
  for s in screen do
      s.dashboard.visible = v
  end
end

-- Exposed function to allow you to bind showing the dashboard.
show_dashboard = function()
  keygrabber = awful.keygrabber.run(function(_, key, event)
      if event == "release" then
        return
      end

      if key == 'Escape' then
        hide_dashboard()
      end
  end)

  set_visibility(true)
end

hide_dashboard = function()
  awful.keygrabber.stop(keygrabber)
  set_visibility(false)
end


local function generate_screen_mask(s, bg_color)
  local mask = wibox({
      visible = false,
      ontop   = true,
      type    = "splash",
      screen  = s,
      bg      = bg_color
  })

  awful.placement.maximize(mask)

  return mask
end

local function worker(columns)
  dashboard = wibox({
      visible = false,
      ontop   = true,
      type    = "dock",
      screen  = screen.primary,
      bg      = dashboard_bg,
      fg      = dashboard_fg
  })

  awful.placement.maximize(dashboard)

  dashboard:buttons(
    gears.table.join(
      awful.button({  }, 2, hide_dashboard)
    )
  )

  for s in screen do
    if s == screen.primary then
      s.dashboard = dashboard
    else
      s.dashboard = generate_screen_mask(s, dashboard.bg)
    end
  end

  -- All data comes in as a two level setup, with the first level being
  -- horizontally laid out, and each column being vertically laid out.
  columns["layout"] = wibox.layout.fixed.horizontal
  for k,v in pairs(columns) do
    if (type(v) == "table") then
      columns[k]["layout"] = wibox.layout.fixed.vertical
    end
  end

  dashboard:setup {
    nil,
    {
      nil,
      columns,
      nil,
      expand = "none",
      layout = wibox.layout.align.horizontal
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
  }

end

setmetatable(dashboard, { __call = function(_, args) return worker(args) end })

return dashboard
