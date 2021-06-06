-- Nix Layer

local M = {}

local arrays  = require("norwyn-vim.utilities.arrays")
local cmd     = require("norwyn-vim.config.helpers").cmd
local loading = require("norwyn-vim.config.loading")

function M.plugins(opts)
  return {
    ["LnL7/vim-nix"] = { },
  }
end

function M.pre_config(opts)
end

function M.config(opts)
end

function M.post_config(opts)
end

return M

