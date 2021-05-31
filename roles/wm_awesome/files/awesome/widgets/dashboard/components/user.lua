-- Dashboard Widget: User Tile
--
-- Requires the following arguments provided in the arguments table:
-- - picture [String] THe path to a picture file to pass as the profile/display picture
-- - width [DPI Calculated Value] The width of the tile; e.g. dpi(400)
-- - height [DPI Value] the height of the tile; e.g. dpi(450)
--
-- The following optional arguments override default functionality:
-- - username_font [String] The font spec to use for the username tex.
-- - hostname_font [String] The font spec to use for the hostname text
local _user = {  }

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local xrdb = require("beautiful.xresources").get_current_theme()
local utils = require("widgets.dashboard.utils")

local function worker(args)
  local container = wibox.container.background()
  --container.shape = utils.prrect(dpi(100), true, true, true, true)
  container.shape = gears.shape.circle
  container.forced_height = dpi(150)
container.forced_width = dpi(150)

  local picture = wibox.widget {
    widget = wibox.container.background,
    shape = utils.rrect( dpi(2) / 2 ),
    {
      wibox.widget.imagebox(args.picture),
      widget = container
    }
  }

  local username = os.getenv("USER")
  local user_text = wibox.widget.textbox(username:upper())
  user_text.font = args.username_font or "San Francisco Display Heavy 16"
  user_text.align = "center"
  user_text.valign = "center"

  local host_text = wibox.widget.textbox()
  awful.spawn.easy_async_with_shell("hostname", function(out)
    out = out:gsub('^%s*(.-)%s*$', '%1')
    host_text.markup = utils.colorize_text("@"..out, x.color8)
  end)
  host_text.font = args.hostname_font or "monospace 16"
  host_text.align = "center"
  host_text.valign = "center"

  local user_widget = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    picture,
    -- utils.vertical_pad(dpi(24)),
    user_text,
    -- utils.vertical_pad(dpi(4)),
    host_text,
  }

  return utils.create_tile(user_widget, args.width, args.height, xrdb.background)
end

setmetatable(_user, { __call = function(_, args) return worker(args) end })

return _user
