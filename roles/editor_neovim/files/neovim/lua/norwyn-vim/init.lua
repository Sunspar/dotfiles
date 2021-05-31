local M = {}

local lume    = require("norwyn-vim.dependencies.lume")
local helpers = require("norwyn-vim.config.helpers")
local loading = require("norwyn-vim.config.loading")

-- Layers to potentially hook up during start up.
--
-- Layers are distinct portions of configuration that provide plugins, custom methods, and keybinds
-- that work together in order to provide pieces of functionality. All layers can be disabled at will
-- without affecting other layers nor the overall configuration. While I normally run with all layers
-- enabled, you may find it necessary to disable things you arent using -- for example git plugins and
-- related functionality may not be useful to you if you primarily use SVN or TFS.

-- Each module consists of one or more files in the fnl/layers directory. The module name should always
-- map to a top-level folder under /layers. At minimum, a module is expected to provide the following:
-- 
-- - a folder named after the module in lua/layers/
-- - an init.lua file which is automatically required during initialization if this module is listed in
--     the module list
-- - a `plugins` function which provides the plugins and default configuration for any plugins that are
--     required for the module to function.
-- - a `configure` function that sets up any key bindings, vim variables, etc.
--
-- Configuration must be loaded in a semi-specific order. In specific, the core functionality needs to be loaded
-- before any of the language or feature specific stuff.
--
-- In general, layers are loaded in tiers:
-- - core layers are always loaded first
-- - feature layuers are loaded after core layers
-- - language layers are loaded at least after the feature layers
-- - frameworks that require multiple language layers are loaded
local layer_load_order = {
  "ansible",
  "colors",
  "core",
  "csv",
  "dart",
  "debugger",
  "elixir",
  "git",
  "graphql",
  "helm",
  "html",
  "intellisense",
  "interface",
  "javascript",
  "keybind_help",
  "lua",
  "markdown",
  "nix",
  "ruby",
  "rust",
  "search",
  "terraform",
  "testing",
  "typescript",
  "vuejs",
}

local function initialize(args)
  local plugins = {}
  local layers = {}
  local layer_list = args.layers or {}
  local bundle_path = args.bundle_path or "~/.config/nvim/bundle"
  
  -- Gather the list of all plugins with their options tables from all activated layers
  for _, layer_name in ipairs(layer_load_order) do
    if (layer_list[layer_name]) then
      local layer_opts = layer_list[layer_name]
      local layer_plugins = require("norwyn-vim.layers."..layer_name).plugins(layer_opts)
      -- TODO:  Support multiple layers defining plugins in a merge-attributes fashion
      --        Currently, we dedup plugins by simply following last-write-wins, which will
      --        cause problems it two layers define the plugin slightly differently. This
      --        -likely- isnt an issue until we have to start lazy-loading things.
      for plugin_name, plugin_opts in pairs(layer_plugins) do
        plugins[plugin_name] = plugin_opts
      end
    end
  end

  -- Load all plugins, and assign global variables to mark them as being loaded.
  vim.fn["plug#begin"](bundle_path)
  for plugin_name, plugin_opts in pairs(plugins) do
    if helpers.is_a(plugin_opts, "string") then
      vim.fn["plug#"](plugin_name)
    elseif helpers.is_a(plugin_opts, "table") and lume.count(plugin_opts) == 0 then
      vim.fn["plug#"](plugin_name)
    elseif helpers.is_a(plugin_opts, "table") and lume.count(plugin_opts) > 0 then
      vim.fn["plug#"](plugin_name, plugin_opts)
    end
    loading.set_plugin_loaded(plugin_name)
  end
  vim.fn["plug#end"]()

  -- Run active layer pre_config() functions
  for _, name in ipairs(layer_load_order) do
    if (layer_list[name]) then
      require("norwyn-vim.layers." .. name).pre_config(layer_list[name])
      loading.set_layer_loaded(name)
    end
  end

  -- Run active layer config() functions
  for _, name in ipairs(layer_load_order) do
    if (layer_list[name]) then
      require("norwyn-vim.layers." .. name).config(layer_list[name])

    end
  end
  
  -- Run active layer post_config() functions
  for _, name in ipairs(layer_load_order) do
    if (layer_list[name]) then
      require("norwyn-vim.layers." .. name).post_config(layer_list[name])
    end
  end
end

-- Set the table up so that you can use the call syntax on it to run the initialize method
-- without having to destructure it first.
setmetatable(M, { __call = function(_, args) return initialize(args) end })
return M

