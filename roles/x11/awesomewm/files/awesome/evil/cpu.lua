-- Signal Provider: evil::cpu(used_percentage)
--
-- Return values:
-- - used_pct [Integer] The percentage of CPU currently used

local awful = require("awful")

-- The refresh interval in seconds.
local interval = 5

local script = [[
    sh -c "
      vmstat 1 1 | tail -1 | awk '{printf \"%d\", \$15}'
    "
]]

awful.widget.watch(script, interval, function(_widget, stdout)
  awesome.emit_signal("evil::cpu", 100 - tonumber(stdout))
end)
