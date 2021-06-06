local M = {}

-- Check whether a string starts with a second string.
-- @param str The string to test
-- @param prefix The prefix to test for
-- @return Whether or not the string begins with the given prefix string.
function M.starts_with(str, prefix)
  return str:sub(1, #prefix) == prefix
end

-- Trim whitespace from the "right" of the string.
-- @param str The string to manipulate
-- @return The string without any trailing whitespace.
function M.rtrim(str)
  -- String as much proceeding whitespace after the final non-whitespace
  -- character as possible.
  return str:match('^(.*%S)%s*$') or ''
end

-- Trim whitespace from the "left" of the string.
-- @param str The string to manipulate
-- @return The string without preceeding whitespace.
function M.ltrim(str)
  -- Strip as much preceeding whitespace as popssible.
  return str:match('^%s*(%S.*)$') or ''
end

-- Trim whitespace from a string in both directions.
-- @param str The string to manipulate
-- @return a string without any preceeding or trailing whitespace
function M.trim(str)
  -- %S matches "non-whitespace", and should pick up the last matching character
  -- in the input string. If it cant, it means there was only whitespace, and
  -- we can cheat by returning an empty string as thats all that can be left
  -- after removing whitespace.
  return str:match('^%s*(.*%S)%s*$') or ''
end

return M
