local M = {}

local loading = require("norwyn-vim.config.loading")

function M.plugins(opts)
  return {
    ["pangloss/vim-javascript"] = { },
    ["prettier/vim-prettier"] = { ["do"] = "yarn install" },
  }
end

function M.pre_config(opts)
end

function M.config(opts)
end

function M.post_config(opts)
end

return M

