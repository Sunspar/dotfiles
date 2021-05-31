local beautiful     = require("beautiful")
beautiful.init(string.format("%s/.config/awesome/themes/nord/theme.lua", os.getenv("HOME")))

-- Now that beautiful has run, we can properly use stuff like xrdb color values
x = beautiful.xresources.get_current_theme()
dpi = beautiful.xresources.apply_dpi

require("themes.nord.topbar")
require("themes.nord.titlebars")
--require("themes.amarena-elenapan.taglist_bar")
