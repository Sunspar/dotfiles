-- Dashboard Widget: Disk Usage
--

local _widget = {}

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local xrdb = require("beautiful.xresources").get_current_theme()
local utils = require("widgets.dashboard.utils")

local function worker(args)
  local arc_widget = wibox.widget {
    start_angle   = 3 * math.pi / 2,
    min_value     = 0,
    max_value     = 100,
    value         = 0,
    border_width  = 0,
    thickness     = dpi(8),
    forced_width  = dpi(100),
    forced_height = dpi(100),
    rounded_edge  = true,
    bg            = xrdb.color8.."55",
    colors        = { xrdb.color13 },
    widget        = wibox.container.arcchart,
  }

  local hover_text_value_widget = wibox.widget {
    align  = "center",
    valign = "center",
    font   = "sans medium 13",
    widget = wibox.widget.textbox(),
  }

  local hover_text_widget = wibox.widget {
    hover_text_value_widget,
    {
      align  = "center",
      valign = "center",
      font   = "sans medium 10",
      widget = wibox.widget.textbox("free")
    },
    spacing = dpi(2),
    visible = false,
    layout  = wibox.layout.fixed.vertical,
  }

  local icon_widget = wibox.widget {
    align  = "center",
    valign = "center",
    font   = "icomoon 23",
    markup = utils.colorize_text("", x.color4),
    widget = wibox.widget.textbox()
  }

  local disk_widget = wibox.widget {
    {
      nil,
      hover_text_widget,
      expand = "none",
      layout = wibox.layout.align.vertical,
    },
    icon_widget,
    arc_widget,
    top_only = false,
    layout   = wibox.layout.stack,
  }

  local tile = utils.create_tile(disk_widget, args.width, args.height, xrdb.background)

  tile:connect_signal("mouse::enter", function()
    icon_widget.visible = false
    hover_text_widget.visible = true
  end)

  tile:connect_signal("mouse::leave", function()
    icon_widget.visible = true
    hover_text_widget.visible = false
  end)

  -- When we get changes from the disk stats, update the widget
  awesome.connect_signal("evil::disk", function(used, total)
    arc_widget.value = used * 100 / total
    hover_text_value_widget.markup = utils.colorize_text(tostring(total - used).."G", xrdb.color4)
  end)

  return tile
end

setmetatable(_widget, { __call = function(_, args) return worker(args) end })

return _widget
