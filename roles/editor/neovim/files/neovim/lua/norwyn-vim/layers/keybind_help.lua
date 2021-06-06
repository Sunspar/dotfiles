-- layers.keybinds -- For when you dont know how to do

local M = {}

local keybind = require("norwyn-vim.config.keybind")

function M.plugins(opts)
  return {
    ["liuchengxu/vim-which-key"] = { }
  }
end

function M.pre_config(opts)
  -- The vim which key map that layers can use to set up keybind help text.
  norwyn_which_key_map = {}
end

function M.config(opts)
  -- Set the Vim-which-key keybinding
  local escaped_leader = vim.g.mapleader:gsub("'", "\\'")

  -- Set whichkey binding
  keybind:new()
    :cmd(escaped_leader)
    :expr(string.format(":WhichKey '%s'<CR>", escaped_leader))
    :noremap()
    :build()
 
  -- No floating windows
  --vim.g.which_key_use_floating_win = 0
  if (opts.disable_floating_win) then vim.g.which_key_use_floating_win = 0 end

  -- Separator character
  vim.g.which_key_sep = opts.which_key_separator or " → "
end

function M.post_config(opts)
  -- Assign finalized key map into vim-which-key
  vim.g.which_key_map = norwyn_which_key_map
  vim.fn["which_key#register"](vim.g.mapleader, "g:which_key_map")
end

return M
