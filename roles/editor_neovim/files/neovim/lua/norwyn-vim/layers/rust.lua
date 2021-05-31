-- Rust IDE Layer

local M = {}

local arrays = require("norwyn-vim.utilities.arrays")
local binding = require("norwyn-vim.config.binding")
local loading = require("norwyn-vim.config.loading")
local tables  = require("norwyn-vim.utilities.tables")

local cmd = vim.api.nvim_command

function M.plugins(opts)
  return {
    ["rust-lang/rust.vim"] = { },
  }
end

function M.pre_config(opts)
end

function M.config(opts)
  cmd('syntax enable')
  cmd('filetype plugin indent on')

  if tables.has_key(opts, 'rustfmt_autosave') then
    vim.g.rustfmt_autosave = opts.rustfmt_autosave
  end
  -- keybind:new()
  --   :autocmd()
  --   :filetype("rust")
  --   :mode("n")
  --   :lcmd("ff")
  --   :expr(":RustFmt<CR>")
  --   :buffer()
  --   :silent()
  --   :build()

  binding.bind_filetype("rust", "n", "<leader>ff", ":RustFmt<CR>", {buffer=true, silent=true})

  if loading.layer_loaded('intellisense') then
    arrays.push(norwyn_intellisense_coc_global_extensions, 'coc-rust-analyzer')
  end
end

function M.post_config(opts)
end

return M
 
