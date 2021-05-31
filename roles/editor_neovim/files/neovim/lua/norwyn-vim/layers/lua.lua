-- Ruby IDE Layer

local M = {}

local arrays = require("norwyn-vim.utilities.arrays")
local loading = require("norwyn-vim.config.loading")

function M.plugins(opts) 
  return {
    ["tbastos/vim-lua"] = { }
  }
end

function M.pre_config(opts)
end

function M.config(opts)
  vim.g.lua_syntax_fancynotequal = 1

  if loading.layer_loaded('intellisense') then
    arrays.push(norwyn_intellisense_coc_global_extensions, 'coc-lua')
  end
end

function M.post_config(opts)
end

return M
