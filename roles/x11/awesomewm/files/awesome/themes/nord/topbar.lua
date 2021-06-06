local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local naughty   = require ("naughty")
local wibox     = require("wibox")
local helpers   = require("helpers")


-- Taken from helpers
-- Mostly putting this here so that the topbar config can live in isolation and avoid the local dependency back
-- Useful for if I want to later uise this taskbar in another theme or a different setup entirely
local function colorize_text(txt, fg)
    return "<span foreground='" .. fg .."'>" .. txt .. "</span>"
end

local function rounded_bar_widget(color)
    return wibox.widget {
        max_value     = 100,
        value         = 0,
        forced_width  = beautiful.bar_width,
        margins       = {
            top = beautiful.bar_margin,
            bottom = beautiful.bar_margin,
        },
        shape         = gears.shape.rounded_bar,
        border_width  = beautiful.bar_border,
        color         = color,
        background_color = beautiful.bar_bg,
        border_color  = beautiful.bar_bordercolor,
        widget        = wibox.widget.progressbar,
    }
end

-- Mouse bindings for taglist items
local taglist_bindings = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Handler for updating the taglist when clicking buttons
local update_taglist = function (item, tag, index)
    if tag.selected then
        item.markup = colorize_text(beautiful.taglist_text_focused[index], beautiful.taglist_fg_focus)
    elseif tag.urgent then
        item.markup = colorize_text(beautiful.taglist_text_urgent[index], beautiful.taglist_fg_urgent)
    elseif #tag:clients() > 0 then
        item.markup = colorize_text(beautiful.taglist_text_occupied[index], beautiful.taglist_fg_occupied)
    else
        item.markup = colorize_text(beautiful.taglist_text_empty[index], beautiful.taglist_fg_empty)
    end
end

-- Hook up topbar for every screen when it connects
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tags, generated with the initial default layout
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- System tray support
    s.my_systray = wibox.widget.systray()
    s.my_systray.visible = false

    -- Create a lua quickprompt
    s.my_promptbox = awful.widget.prompt()

    -- Clocks
    s.my_textclock = wibox.widget.textclock()

    -- Create the tag layout section which displays which tags have clients, and what the current tag is.
    s.my_taglist = awful.widget.taglist {
      screen = s,
      filter = awful.widget.taglist.filter.all,
        widget_template = {
          widget = wibox.widget.textbox,
          create_callback = function(self, tag, index, _)
            self.align = "left"
            self.valign = "center"
            self.font = beautiful.taglist_text_font

            update_taglist(self, tag, index)
          end,
          update_callback = function(self, tag, index, _)
            update_taglist(self, tag, index)
          end,
        },
        buttons = taglist_bindings
    }

    -- Tasklist widget
    s.my_tasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.focused,
        widget_template = {
            {
              {
                  id     = 'clienticon',
                  widget = awful.widget.clienticon,
              },
              margins = 5,
              widget  = wibox.container.margin
            },
            nil,
            layout = wibox.layout.align.vertical,
        }
    }

    s.my_layoutbox = awful.widget.layoutbox(s)
    s.my_layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Create the widget bar and run the setup that wires everything up
    s.my_wibar = awful.wibar({
        position = "top",
        screen   = s,
        bg       = beautiful.bg_normal
    })

    s.my_wibar:setup {
        layout = wibox.layout.align.horizontal,
	    expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.my_taglist,
            s.my_promptbox,
        },
        s.my_textclock,--s.mytasklist, -- Middle widget
        { -- Right widgets
	    layout = wibox.layout.fixed.horizontal,
            s.my_systray,
            s.my_tasklist,
            s.my_layoutbox,
        },
    }
end)
