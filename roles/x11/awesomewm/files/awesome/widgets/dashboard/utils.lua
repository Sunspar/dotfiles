local utils = { }

local gears = require("gears")
local wibox = require("wibox")

utils.rrect = function(radius)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

utils.colorize_text = function(text, color)
  return "<span foreground='"..color.."'>"..text.."</span>"
end

utils.create_tile = function(widget, width, height, bg_color)
  local tile_container = wibox.container.background()
  tile_container.bg = bg_color
  tile_container.forced_width = width
  tile_container.forced_height = height
  tile_container.shape = utils.rrect(dpi(6))

  -- Generate the tile.
  -- Tiles are widgets with padding around them and centered content, both vertically and horizontally.
  return wibox.widget({
      widget = wibox.container.margin,
      color = "#FF000000",
      margins = dpi(6),
      {
        widget = tile_container,
        {
          layout = wibox.layout.align.horizontal,
          expand = "none",
          nil,
          {
            layout = wibox.layout.align.vertical,
            expand = "none",
            nil,
            widget
          }
        }
      }
  })
end

utils.prrect = function(radius, tl, tr, br, bl)
    return function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
    end
end

utils.vertical_pad = function(height)
    return wibox.widget{
        forced_height = height,
        layout = wibox.layout.fixed.vertical
    }
end



return utils
