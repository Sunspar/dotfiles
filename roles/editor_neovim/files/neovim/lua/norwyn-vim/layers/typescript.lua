-- Typescript IDE Layer

local M = {}

local loading = require("norwyn-vim.config.loading")
local arrays  = require("norwyn-vim.utilities.arrays")

function M.plugins(opts)
  return {
    ["leafgarland/typescript-vim"] = { },
    ["prettier/vim-prettier"] = { ["do"] = "yarn install" },
  }
end

function M.pre_config(opts)
end

function M.config(opts)
  if loading.layer_loaded('frameworks-vuejs') then
    arrays.push(norwyn_frameworks_vuejs_preprocessors, 'scss')
    arrays.push(norwyn_frameworks_vuejs_preprocessors, 'ts')
  end

  if loading.layer_loaded('intellisense') then
    arrays.push(norwyn_intellisense_coc_global_extensions, "coc-tsserver")
  end
end

function M.post_config(opts)
end

return M

