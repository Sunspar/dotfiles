-- Colorscheme: Because text deserves to be pretty

-- Options
--
-- The following color schemes are supported by passing in the colorscheme name as the `theme` key. As this
-- affects plugins you may need to run a `:PlugInstall` to fetch them if its the first time using the theme:
-- - nord
-- - zephyr
-- - dracula
--

local M = {}

function M.plugins(opts)
  local mapping = {
    nord    = {
      ["arcticicestudio/nord-vim"] = { }
    },
    zephyr  = {
      ["glepnir/zephyr-nvim"]             = { },
      ["nvim-treesitter/nvim-treesitter"] = { }
    },
    dracula = {
      ["dracula/vim"] = { ["as"] = "dracula-vim" }
    }
  }

  return mapping[opts.theme] or {}
end

function M.pre_config(opts)
end

function M.config(opts)
  vim.cmd("colorscheme " .. opts.theme)
end

function M.post_config(opts)
end

return M
