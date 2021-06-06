local M = {}

local tables  = require("norwyn-vim.utilities.tables")

function M.plugins(opts)
  return {
    ["hashivim/vim-terraform"] = {},
  }
end

function M.pre_config(opts)
end

function M.config(opts)
  if (plugin_loaded("vim-terraform")) then
    if (tables.has_key(opts, 'format_on_save')) then
      vim.g.terraform_fmt_on_save = 1
    end

    if (tables.has_key(opts, 'terraform_bin')) then
      vim.g.terraform_binary_path = opts.terraform_bin
    end
  end
end

function M.post_config(opts)
end

return M

