-- VCS - Git: the one VCS to rule them all

local M = {}

function M.plugins(opts)
  return {
    -- Git interactivity via vim
    ["jreybert/vimagit"]  = { },
    -- Gutter symbols for file diffs
    ["mhinz/vim-signify"] = { },
  }
end

function M.pre_config(opts)
end

function M.config(opts)
end

function M.post_config(opts)
end

return M

