local M = {}

M.expand = function(path)
  return vim.fn.expand(path)
end

M.glob = function(path)
  return vim.fn.glob(path, true, true, true)
end

M.exists = function(path)
  return vim.fn.filereadable(path)
end

M.luafile = function(path)
  return vim.ex.luafile(path)
end

M.error = function(content)
  return vim.api.nvim_err_writeln(content)
end

M.is_a = function(instance, type_name)
  return type(instance) == type_name
end

M.cmd = function(command_string)
    vim.api.nvim_command(command_string)
end

M.floating_window = function()
  local width = vim.o.columns
  local height = vim.o.lines
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  if (width > 150) or (height > 35) then
    local win_height = math.min(math.ceil(height * 0.75), 30)
    local win_width = 0
    if (width < 150) then
      win_width = math.ceil(width - 8)
    else
      win_width = math.ceil(width * 0.9)
    end
    local opts = {
      col = math.ceil((width - win_width) / 2), 
      height = win_height,
      relative = "editor",
      row = math.ceil(((height - win_height) / 2)),
      width = win_width}
    local win = vim.api.nvim_open_win(buf, true, opts)
    return nil
  end
end

return M
