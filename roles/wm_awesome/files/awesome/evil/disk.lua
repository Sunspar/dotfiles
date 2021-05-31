-- Signal Provider: evil::disk
--
-- Return values: (used, total)
-- - used [Integer] The used disk usage in GB.
-- - total [Integer] The total disk size in GB.

local awful = require("awful")
local naughty = require("naughty")

-- The update interval, in seconds.
local interval = 300

-- The script. Change the disk per your setup.
-- TODO: Parameterize this, so we can also scan multiple drives
local script = [[ bash -c "df -kh /dev/sdb2 | tail -1 | awk '{printf \"%d@%d\", \$4, \$3}'" ]]

awful.widget.watch(script, interval, function(_widget, stdout, stderr, exitreason, exitcode)
  -- Debug command output by uncommenting these lines
  -- naughty.notify({ text = "CMDSTR: " .. script })
  -- naughty.notify({ text = "STDOUT: " .. stdout })
  -- naughty.notify({ text = "STDERR: " .. stderr })
  -- naughty.notify({ text = "EXTRSN: " .. exitreason })
  -- naughty.notify({ text = "EXTCOD: " .. exitcode })

  -- We get "total" as available + used, since the total size reported by
  -- `df` includes the 5% reserved storagge for the root user.
  local available = stdout:match('^(.*)@')
  local used = stdout:match('@(.*)$')
  awesome.emit_signal("evil::disk", tonumber(used), tonumber(used) + tonumber(available))
end)
