-- VueJS: The Progressive Front-end Stack

local M = {}

function M.plugins(opts)
  return {
    ["posva/vim-vue"] = { }
  }
end

function M.pre_config(opts)
  norwyn_frameworks_vuejs_preprocessors = { "scss" }
end

function M.config(opts)
end

function M.post_config(opts)
  -- whitelist expected preprocessors to improve loading times.
  -- See: https://github.com/posva/vim-vue#vim-slows-down-when-using-this-plugin-how-can-i-fix-that

  -- It is expected that language specific layers for frontend languages attach to the
  -- `norwyn_frameworks_vuejs_preprocessor_list` variable during bootup if `vim-vue` is an enabled plugin.

  -- This list is an unsorted index-like table. You can add entries to it with:
  -- `require("utilities.array").push(var, item)`
  vim.g.vue_pre_processors = norwyn_frameworks_vuejs_preprocessors
end

return M
