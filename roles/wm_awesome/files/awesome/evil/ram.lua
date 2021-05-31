-- Signal Provider: evil::ram(total, available)
--
-- Return values:
-- - total [Integer] the total amount of RAM on the system.
-- - available [Integer] the free amount of RAM

local awful = require("awful")

-- The refresh interval in seconds.
local interval = 20

-- The output of free lists category   total,used,free,shared,cacche,avail.
-- We want to calculate the ratio of free memory available, which means we want used / total as the total utilization.
local script = [[
  bash -c "
    free -m | grep 'Mem:' | awk '{printf \"%d@%d\", \$7, \$2}'
  "
]]

awful.widget.watch(script, interval, function(_widget, stdout)
  local available, total = stdout:match('(.*)@(.*)')
  available = tonumber(available)
  total = tonumber(total)
  local used = total - available
  awesome.emit_signal("evil::ram", used, total)
end)
