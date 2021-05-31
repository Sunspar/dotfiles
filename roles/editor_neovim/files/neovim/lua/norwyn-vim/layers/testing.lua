-- Test Runner support

local M = {}

local helpers = require("norwyn-vim.config.helpers")
local plugin_loaded = helpers.plugin_loaded
local layer_loaded = helpers.layer_loaded
local keybind = require("norwyn-vim.config.keybind")


local function set_keybinds()
  norwyn_which_key_map["t"] = { name = "+testing" }

  keybind:new()
    :lcmd("tf")
    :expr(":TestFile<CR>")
    :noremap()
    :help("Test file")
    :build()

  keybind:new()
    :lcmd("tc")
    :expr(":TestNearest<CR>")
    :noremap()
    :help("Run nearest test")
    :build()
end

function M.plugins(opts)
  return {
    ["vim-test/vim-test"] = { },
  }
end

function M.pre_config(opts)
end

function M.config(opts)
  set_keybinds()
end

function M.post_config(opts)
end

return M
