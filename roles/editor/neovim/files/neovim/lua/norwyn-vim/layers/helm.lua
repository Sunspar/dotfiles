-- Helm: Kubernetes on steroids

local M = {}

function M.plugins(opts)
  return {
    ["towolf/vim-helm"] = { }
  }
end

function M.pre_config(opts)
end

function M.config(opts)
end

function M.post_config(opts)
end

return M

