
-- Sunspar's Awesome Window Manager Dock
--
-- A themeable, customizable dock that gets out of your way when you dont need it.
--
--
-- The dock module exposes an init method that allows you to pass in the following table:
-- - items: An array of tables where each item represents a dock icon to interact with. The icon tables themselves support
--     the following fields:
--     - icon: The icon for the button to use
--     - handlers = a gears table of event handlers for various interactions with the dock item



-- Standard import stuff
local awful = require("awful")
