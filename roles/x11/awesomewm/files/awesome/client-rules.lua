local awful     = require("awful")
local beautiful = require("beautiful")
local tags      = awful.util.tagnames

local bindings = require("bindings")

return {
  -- All clients will match this rule.
  { rule = { },
    properties = { border_width = beautiful.border_width,
                   border_color = beautiful.border_normal,
                   focus = awful.client.focus.filter,
                   raise = true,
                   keys = bindings.client_keyboard_bindings,
                   buttons = bindings.client_mouse_bindings,
                   screen = awful.screen.preferred,
                   placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                   size_hints_honor = false,
    }
  },

  -- All dialog windows get titlebars
  { rule_any = { type = { "dialog", "floating" } }, properties = { titlebars_enabled = true } },

  -- Start some applications on specific tags.
  { rule = { instance = "emacs" }, properties = { screen = 1, tag = tags[1] } },
  { rule = { class = "firefox" }, properties = { screen = 1, tag = tags[2] } },
  { rule = { instance = "lens" }, properties = { screen = 1, tag = tags[3] } },
  { rule = { instance = "wow.exe" }, properties = { screen = 1, tag = tags[7] } },
  { rule = { instance = "spotify" }, properties = { screen = 2, tag = tags[5] } },
  { rule_any = { instance = { "slack", "discord" } }, properties = { screen = 2, tag = tags[9] } },
}
