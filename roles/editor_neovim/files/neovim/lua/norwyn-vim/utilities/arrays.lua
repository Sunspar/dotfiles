-- Array-like utilities for Lua Tables.

local M = {}

-- Push item into a table that mimics an array
--
-- Push items into an array in tail position.
--
-- Example:
--   push({ "a", "b"}, "3") --> { "a", "b", "3" }
function M.push(t, ...)
  local n = select("#", ...)
  for i = 1, n do
    t[#t + 1] = select(i, ...)
  end
  return ...
end


return M

