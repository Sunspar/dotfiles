local M = {}

function M.has_key(tbl, key)
  return tbl[key] ~= nil
end

return M
