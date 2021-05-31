local M = {}

function M.plugins(opts)
  return { }
end

function M.pre_config(opts)
  -- Leader key for keybindings
  -- Needs to be a pre_config assignment or else keybind_help wont initialize properly
  vim.g.mapleader = opts.leaderkey or ","
end

function M.config(opts)
  vim.wo.number         = true
  vim.wo.relativenumber = true
  vim.o.mouse           = "a"
  vim.o.tabstop         = 2
  vim.o.shiftwidth      = 2
  vim.o.expandtab       = true
  vim.o.autoindent      = true
  vim.o.smartindent     = true
  vim.o.cindent         = true

  -- Setting the clipboard like this allows for passing data between vim and the system clipboard
  vim.api.nvim_command('set clipboard+=unnamedplus')

  -- Let buffers with changes go to the background
  vim.o.hidden          = true
end

function M.post_config(opts)
end

return M
