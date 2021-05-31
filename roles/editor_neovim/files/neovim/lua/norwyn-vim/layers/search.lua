-- Search: For when you need to find stuff

local M = {}

local loading = require("norwyn-vim.config.loading")
local keybind = require("norwyn-vim.config.keybind")

function M.plugins(opts)
  return {
    ["junegunn/fzf"]      = { ["do"] = "./install --all", dir = "~/.fzf" },
    ["junegunn/fzf.vim"]  = { },
  }
end

function M.pre_config(opts)
end

function M.config(opts)
  vim.g.fzf_layout = {
    window = "lua require('norwyn-vim.config.helpers').floating_window()"
  }
 
  if (loading.layer_loaded("keybind_help")) then
    norwyn_which_key_map["s"] = { name = "+search" }
  end

  keybind:new()
    :lcmd("sf")
    :expr(":Files<CR>")
    :noremap()
    :help("search files with fzf")
    :build()

  keybind:new()
    :lcmd("sg")
    :expr(":GFiles<CR>")
    :noremap()
    :help("search git files")
    :build()

  keybind:new()
    :lcmd("sc")
    :expr(":Rg<CR>")
    :noremap()
    :help("search content")
    :build()

  keybind:new()
    :lcmd("sb")
    :expr(":Lines<CR>")
    :noremap()
    :help("search lines")
    :build()
end

function M.post_config(opts)
end

return M
