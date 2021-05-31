-- Intellisense: Because you're intelligent, and so am I!

local M = {}

function M.plugins(opts)
  return { 
    -- Intellisense
    ["neoclide/coc.nvim"] = { branch = "release" },
  }
end

function M.pre_config(opts)
  norwyn_intellisense_coc_global_extensions = {}
end

function M.config(opts)  
end

function M.post_config(opts)
  vim.g.coc_global_extensions = norwyn_intellisense_coc_global_extensions
end

return M


