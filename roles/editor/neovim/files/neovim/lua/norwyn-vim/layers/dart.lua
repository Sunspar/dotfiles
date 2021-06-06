local M = {}

function M.plugins(opts)
  return {
    ["dart-lang/dart-vim-plugin"] = {},
    ["thosakwe/vim-flutter"] = {},
  }
end

function M.pre_config(opts)
end

function M.config(opts)
  vim.g["dart_format_on_save"] = true
  vim.g["dart_style_guide"] = 2
end

function M.post_config(opts)
end

return M

