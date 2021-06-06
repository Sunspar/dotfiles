local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local dpi       = require("beautiful.xresources").apply_dpi
local theme     = require("themes.nord.theme")

-- Generates a fleshed out widget that acts as a titlebar button.
local function create_button_widget(c, color, hover_color, command)
  local button = wibox.widget {
    widget        = wibox.container.background(),
    shape         = gears.shape.circle,
    forced_height = dpi(8),
    forced_width  = dpi(8),
    bg            = theme.nord8
  }

  local button_widget = wibox.widget {
    widget  = wibox.container.margin(),
    margins = dpi(6),
    button
  }

  -- trigger commands when clicking the widgets
  button_widget:buttons(gears.table.join(
    awful.button({}, 1, function() command(c) end)
  ))

  -- Support hover effects
  button_widget:connect_signal("mouse::enter", function()
      button.bg = hover_color
  end)

  button_widget:connect_signal("mouse::leave", function()
    if c == client.focus then
      button.bg = color
    else
      button.bg = theme.nord8
    end
  end)

    -- Focusing the related client
  c:connect_signal("focus", function()
    button.bg = color
  end)

  c:connect_signal("unfocus", function()
    button.bg = theme.nord8
  end)

  return button_widget
end

local function titlebar_shape(radius)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, radius)
  end
end

local function minimize_window(c)
  c.minimized = true
end

local function maximize_window(c)
  c.maximized = not c.maximized
  c:raise()
end

local function close_window(c)
  c:kill()
end

local function titlebar_mouse_bindings(c)
  return gears.table.join(
    awful.button({}, 1, function()
        c:emit_signal("request::activate", "titlebar", {raise = true })
        awful.mouse.client.move(c)
    end)
  )
end

-- Actually hook it up
client.connect_signal("request::titlebars", function(c)
    local titlebar_container = wibox.widget {
      shape  = titlebar_shape(dpi(6)),
      bg     = beautiful.titlebar_bg,
      widget = wibox.container.background,
      buttons = titlebar_mouse_bindings(c)
    }

    local opts = {
      font     = beautiful.font,
      position = "top",
      size     = dpi(20)
    }

    awful.titlebar(c, opts):setup {
      widget = titlebar_container,
      {
        layout = wibox.layout.fixed.vertical,
        {
          layout = wibox.layout.align.horizontal,
          fixed_height = dpi(20),
          nil,
          nil,
          {
            layout = wibox.layout.fixed.horizontal,
            create_button_widget(c, theme.nord3, theme.nord10, minimize_window),
            create_button_widget(c, theme.nord2, theme.nord10, maximize_window),
            create_button_widget(c, theme.nord1, theme.nord11, close_window),
          }
        },
        {
          widget = wibox.container.background,
          bg = beautiful.titlebar_bg,
          forced_height = dpi(6) * 2
        }
      }
    }
end)
