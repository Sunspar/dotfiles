-- Markdown: Typesetting for the Common Folk

local M = {}

function M.plugins(opts)
  return {
    ["godlygeek/tabular"]             = { },
    ["plasticboy/vim-markdown"]       = { },
    ["iamcco/markdown-preview.nvim"]  = { ["do"] = "cd app && yarn install" },
  }
end

function M.pre_config(opts)
end

function M.config(opts)
end

function M.post_config(opts)
end

return M
