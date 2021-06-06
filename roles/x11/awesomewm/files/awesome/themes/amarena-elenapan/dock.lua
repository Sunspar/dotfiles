local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xrdb = require("beautiful.xresources").get_current_theme()
local keybindings = require("bindings")
local dpi = require("beautiful.xresources").apply_dpi

-- Autohide delay for the dock, in seconds.
local autohide_delay = 0.5

-- Colors to use for tags in various states of use.
local tag_color_empty = {
  "#00000000",
  "#00000000",
  "#00000000",
  "#00000000",
  "#00000000",
  "#00000000",
  "#00000000",
  "#00000000",
  "#00000000",
  "#00000000",
}

-- Colors to use when tag has an urgent client present.
local tag_color_urgent = {
  xrdb.foreground,
  xrdb.foreground,
  xrdb.foreground,
  xrdb.foreground,
  xrdb.foreground,
  xrdb.foreground,
  xrdb.foreground,
  xrdb.foreground,
  xrdb.foreground,
  xrdb.foreground,
}

-- Colors to use when the tag is currently holding focus.
local tag_color_focused = {
  xrdb.color1,
  xrdb.color5,
  xrdb.color4,
  xrdb.color6,
  xrdb.color2,
  xrdb.color3,
  xrdb.color1,
  xrdb.color5,
  xrdb.color4,
  xrdb.color6,
}

-- Colors to use when the tag has clients present.
local tag_color_used = {
  xrdb.color1.."45",
  xrdb.color5.."45",
  xrdb.color4.."45",
  xrdb.color6.."45",
  xrdb.color2.."45",
  xrdb.color3.."45",
  xrdb.color1.."45",
  xrdb.color5.."45",
  xrdb.color4.."45",
  xrdb.color6.."45",
}

local function update_taglist(item, tag, index)
  if tag.selected then
    item.bg = tag_color_focused[index]
  elseif tag.urgent then
    item.bg = tag_color_urgent[index]
  elseif #tag:clients() > 0 then
    item.bg = tag_color_used[index]
  else
    item.bg = tag_colors_empty[index]
  end
end

local function dock_placement(widget)
  return awful.placement.bottom(widget)
end

-- Cancels the timer if its currently running.
local function stop_timer(screen_ref)
  return function()
    if screen_ref.dock_timer then
        screen_ref.dock_timer:stop()
        screen_ref.dock_timer = nil
    end
  end
end

-- Fix the dock when the number of items changes.
local function reset_dock_placement(dock_ref, dock_activator_ref)
  return function()
    -- Reset the position
    dock_placement(dock_ref)

    -- Adjust the activator because the width is different.
    dock_activator_ref.width = dock_ref.width + dpi(250)

    -- Recenter the dock in the screen.
    dock_placement(dock_activator_ref)
  end
end

local function hide_activator_on_client(screen_ref)
  return function(client_ref)
    screen_ref.dock_activator.ontop = not client_ref.fullscreen
  end
end

local function autohide_dock(screen_ref)
    return function()
        stop_timer(screen_ref.dock_timer)

        screen_ref.dock_timer = gears.timer.start_new(autohide_delay, function()
            screen_ref.dock_timer = nil
            screen_ref.dock.visible = false
        end)
    end
end

local function rrect(radius)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

-- Screen handler generates a dock unique to each screen.
awful.screen.connect_for_each_screen(function(s)
    -- The timer to use for dealing with the popup and auto-hide functionality.
    s.dock_timer = nil

    -- Create a taglist
    s.dock_taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = keybindings.taglist_button_bindings,
        layout  = {
            layout = wibox.layout.flex.horizontal,
        },
        widget_template = {
            widget = wibox.container.background,
            create_callback = function(self, tag, index, _)
                update_taglist(self, tag, index)
            end,
            update_callback = function(self, tag, index, _)
                update_taglist(self, tag, index)
            end,
        }
    }

    -- Create the taglist's wibox
    s.dock_taglist_box = awful.wibar({
        screen   = s,
        visible  = true,
        ontop    = false,
        type     = "dock",
        position = "top",
        height   = dpi(10),
        bg       = "#00000000",
    })

    s.dock_taglist_box:setup {
      widget = s.dock_taglist
    }

    -- Create the actual dock's wibox
    s.dock = awful.popup({
        visible   = false,
        bg        = "#00000000",
        ontop     = true,
        type      = "dock",
        placement = dock_placement,
        widget    = require("dockmod")
    })

    -- Wibox responsible for triggering the dock's hover show/hide functionality.
    s.dock_activator = wibox({
        screen  = s,
        height  = 1,
        bg      = "#00000000",
        visible = true,
        ontop   = true
    })

    -- On initialization of the screen, run the initial upkeep tasks
    dock_placement(s.dock)
    reset_dock_placement(s.dock, s.dock_activator)()
    awful.placement.bottom(s.dock_activator)

    -- We have the dock on top, but we don't want it to be above fullscreen clients.
    client.connect_signal("focus", hide_activator_on_client(s))
    client.connect_signal("unfocus", hide_activator_on_client(s))
    client.connect_signal("property::fullscreen", hide_activator_on_client(s))

    -- Fix the dock whenever the screen resolution changes.
    s.dock:connect_signal("property::width", reset_dock_placement(s.dock, s.dock_activator))

    -- Stop timer when mouse is placed over the dock area.
    -- s.dock.connect_signal("mouse::enter", stop_timer(s))
    s.dock_activator:connect_signal("mouse::enter", function()
        s.dock.visible = true
        stop_timer(s)()
    end)

    -- Hide the dock automatically when moving the mouse of of the dock's visible space.
    s.dock:connect_signal("mouse::leave", autohide_dock(s))
    s.dock_activator:connect_signal("mouse::leave", autohide_dock(s))
end)


-- Requires the rrect helper function
awful.screen.connect_for_each_screen(function(s)
    s.tray = wibox.widget.systray()

    s.traybox = wibox({
        screen  = s,
        width   = dpi(150),
        height  = beautiful.wibar_height,
        bg      = "#00000000",
        visible = false,
        ontop   = true
    })

    s.traybox:setup {
      {
        {
          nil,
          s.tray,
          expand = "none",
          layout = wibox.layout.align.horizontal,
        },
        margins = dpi(10),
        widget  = wibox.container.margin
      },
      bg     = beautiful.bg_systray,
      shape  = rrect(beautiful.border_radius),
      widget = wibox.container.background
    }

    s.traybox:buttons(gears.table.join(
        awful.button({  }, 2, function()
            s.traybox.visible = false
        end)
    ))

    awful.placement.bottom_right(s.traybox, { margins = beautiful.useless_gap * 2 })
end)
