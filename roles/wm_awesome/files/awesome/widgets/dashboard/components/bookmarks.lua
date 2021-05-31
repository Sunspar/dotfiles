local _widget = {  }

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local xrdb  = require("beautiful.xresources").get_current_theme()
local utils = require("widgets.dashboard.utils")

local function create_item(name, cmd, color, hover_color)
  local result = wibox.widget.textbox()
    result.font   = "sans bold 16"
    result.markup = utils.colorize_text(name, color)
    result.align  = "center"
    result.valign = "center"

    result:buttons(gears.table.join(
      awful.button({  }, 1, function()
        awful.util.spawn_with_shell(cmd)
        hide_dashboard()
      end)
    ))

    result:connect_signal("mouse::enter", function()
      result.markup = utils.colorize_text(name, hover_color)
    end)

    result:connect_signal("mouse::leave", function()
      result.markup = utils.colorize_text(name, color)
    end)

    return result
end

-- Generate the bookmarks widget from an array of tables that represent the items.
local function worker(args)
  local bookmark_list = {
    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical
  }

  for i, data in pairs(args.items) do
    bookmark_list[i] = create_item(data[1], data[2], data[3], data[4])
  end

  return utils.create_tile(wibox.widget(bookmark_list), args.width, args.height, xrdb.background)
end

setmetatable(_widget, { __call = function(_, args) return worker(args) end })

return _widget
