# Norwyn-Vim Neovim Config
My constantly-iterative neovim config files, wrapped up as a pseudo-distribution.

## Basic Usage
TBD

Functionality is provided via a system called "layering". Layers provide a way to enable or disable a part of the system. Generally speaking, layers target a specific aspect of the overall configuration -- providing intellisense, supporting a given language, etc and provide mechanisms for customizing this functionality.

## Loading / Startup Process
Norwyn boots up its environment in the following general procedure:

- Determine the loaded layers
- Consolidate plugins to load from each active layer into one master list, and activate them via vim-plug
- Run any pre-configuration code in each active layer
- Run general layer configuration
- Run any post-configuration cleanup code

## Provided Layers
TBD. A rough list of intended items is:

- features
  - interface
- frameworks
  - vuejs
  - helm
  - ansible
-languages
  - html
  - css
  - scss
  - javascript
  - typescript
  - php
  - erlang
  - elixir
  - lua
  - rust
  - ruby
- colors
- debugger
- intellisense
- testing
- settings

## Design of a Layer
A minimally viable, empty layer could be defined as:

```lua
local M = {}

function M.plugins(opts)
  return { }
end

function M.pre_config(opts)
end

function M.config(opts)
end

function M.post_config(opts)
end

return M


```

### Sub-layers
TBD

### plugins(opts)
Each layer defines a plugins method, with an argument table. This method is responsible for returning a table where:
- keys represent plugins to load via Vim-Plug
- values represent options to pass during plugin initialization

The plugin names should always be full vim-plug references to GitHub repositories, i.e `["user-name/repo-name"]` The values are always Lua tables, with vim-plug keywords that collide with Lua keywords represented wrapped in string quotation marks (most notably `do`).


### config(opts)
A layer's `config()` method is the place where the layer can provide any sort of initialization-time configuration. This is typically where things like custom keybinds or global vim variables are loaded. Like with plugins, you can use the opts table in the first argument to augment the overall configuration of the layer.

The config method is not expected to return a value to later use.

### pre_config(opts)
The `pre_config` method is responsible for any configuration that needs to happen in the first pass. This is the ideal place to initialize globals and perform other work that needs to happen as early in the configuration process as possible. Because layers should care about their load order as little as possible, this is also a good place to perform work you know needs to happen before the bulk of the configuration where dealing with the load order could make your layer's functionality more annoying to deal with.

The pre_config method is not expected to return a value to later use.

### post_config(opts)
A layer's `post_init()` method is the place to perform any cleanup in the final configuration pass. Things that need to happen super late, such as dealingg with temporary values or resolving globals into a plugin are great candidates for work done in a layer's `post_config` method.

The post_config method is not expected to return a value to later use.
