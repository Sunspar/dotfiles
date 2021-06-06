-- Debugger: Vimspector to the rescue!

local M = {}

local helpers       = require("norwyn-vim.config.helpers")
local plugin_loaded = helpers.plugin_loaded
local layer_loaded  = helpers.layer_loaded
local keybind       = require("norwyn-vim.config.keybind")

local function set_bindings() 
  norwyn_which_key_map['d'] = { name = '+debugger' }

  keybind:new()
    :cmd("<F2>")
    :expr(":<C-U>call vimspector#RunToCursor()<CR>")
    :silent()
    :help("Continue until cursor")
    :build()
  
  keybind:new()
    :cmd("<F3>")
    :expr(":<C-U>call vimspector#Stop()<CR>")
    :silent()
    :help("Stop debugger")
    :build()
  
  keybind:new()
    :cmd("<F4>")
    :expr(":<C-U>call vimspector#Restart()<CR>")
    :silent()
    :help("Restart debugger")
    :build()
  
  keybind:new()
    :cmd("<F5>")
    :expr(":<C-U>call vimspector#Continue()<CR>")
    :silent()
    :help("Start/Continue debugger")
    :build()
  
  keybind:new()
    :cmd("<F6>")
    :expr(":<C-U>call vimspector#Pause()<CR>")
    :silent()
    :help("Pause debugger")
    :build()
  
  keybind:new()
    :cmd("<F7>")
    :expr(":<C-U>call vimspector#ToggleConditionalBreakpoint()<CR>")
    :silent()
    :help("Toggle conditional breakpoint")
    :build()
  
  keybind:new()
    :cmd("<F8>")
    :expr(":<C-U>call vimspector#AddFunctionBreakpoint()<CR>")
    :silent()
    :help("Add function breakpoint")
    :build()
  
  keybind:new()
    :cmd("<F9>")
    :expr(":<C-U>call vimspector#ToggleBreakpoint()<CR>")
    :silent()
    :help("Toggle breakpoint")
    :build()
  
  keybind:new()
    :cmd("<F10>")
    :expr(":<C-U>call vimspector#StepOver()<CR>")
    :silent()
    :help("Step over instruction")
    :build()
  
  keybind:new()
    :cmd("<F11>")
    :expr(":<C-U>call vimspector#StepInto()<CR>")
    :silent()
    :help("Step into instruction")
    :build()
  
  keybind:new()
    :cmd("<F12>")
    :expr(":<C-U>call vimspector#StepOut()<CR>")
    :silent()
    :help("Step out of instruction")
    :build()
end

function M.plugins(opts)
  return {
    ["puremourning/vimspector"] = { }
  }
end

function M.pre_config(opts)
end

function M.config(opts)
  set_bindings()
end

function M.post_config(opts)
end

return M

