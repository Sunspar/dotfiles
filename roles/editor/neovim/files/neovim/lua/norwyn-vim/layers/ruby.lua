-- Ruby IDE Layer

local M = {}

local arrays  = require("norwyn-vim.utilities.arrays")
local cmd     = require("norwyn-vim.config.helpers").cmd
local loading = require("norwyn-vim.config.loading")

function M.plugins(opts)
  return {
    ["vim-ruby/vim-ruby"] = { },
    ["tpope/vim-rails"]   = { },
  }
end

function M.pre_config(opts)
end

function M.config(opts)
  -- Setup coc-solargraph for intellisense
  --if loading.layer_loaded('intellisense') then
  --  arrays.push(norwyn_intellisense_coc_global_extensions, 'coc-solargraph')
  --end

  cmd('autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2')
  cmd('autocmd FileType eruby setlocal expandtab shiftwidth=2 tabstop=2')
  cmd('autocmd FileType ruby setlocal commentstring=#\\ %s')
end

function M.post_config(opts)
end

return M
