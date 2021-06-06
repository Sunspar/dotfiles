local M = {}

function M.plugin_variable_name(name)
  return "norwynvim_plugin_loaded_" .. name
end

function M.set_plugin_loaded(name)
  vim.g[M.plugin_variable_name(name)] = 1
end

function M.plugin_loaded(name)
  return vim.g[M.plugin_variable_name(name)] == 1
end

function M.layer_variable_name(name)
  return "norwynvim_layer_loaded_" .. name
end

function M.set_layer_loaded(name)
  vim.g[M.layer_variable_name(name)] = 1
end

function M.layer_loaded(name)
  return vim.g[M.layer_variable_name(name)] == 1
end

return M
