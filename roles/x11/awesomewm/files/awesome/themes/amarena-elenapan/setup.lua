local beautiful = require("beautiful")
beautiful.init(string.format("%s/.config/awesome/themes/amarena-elenapan/theme.lua", os.getenv("HOME")))

x = beautiful.xresources.get_current_theme()
dpi = beautiful.xresources.apply_dpi

require("themes.amarena-elenapan.topbar")
require("themes.amarena-elenapan.titlebars")
