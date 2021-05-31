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


-- Screen handler generates a dock unique to each screen.
awful.screen.connect_for_each_screen(function(s)
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
end)
