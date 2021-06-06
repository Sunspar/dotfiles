local M = {}

local array = require("norwyn-vim.utilities.arrays")

-- Takes a keybind sequence string and returns an "array" of its individual components.
-- 
-- "Complex" characters such as <C-X> or <leader> are supported, but literal "<" and ">" are not.
--
-- Example:
--  split_keybind_string("<leader>fs") --> { "<leader>", "f", "s" }
--  split_keybind_string("<C-F><S-W>q") --> { "<C-F>", "<S-W>", "q" }
--
--  @tparam input string The keybind sequence string
local function split_keybind_string(input)
  local result = {}

  local processing_complex_character = false
  local complex_character = ""

  for character in string.gmatch(input, ".") do

    -- When you see "<", start a complex character
    if character == "<" then
      -- When you see "<", start a complex character
      processing_complex_character = true
      complex_character = character
    elseif character == ">" then
      -- When you see ">", stop the complex character
      complex_character = complex_character .. character
      array.push(result, complex_character)
      complex_character = ""
      processing_complex_character = false
    elseif processing_complex_character then
      -- Non-terminal character in the middle of a complex character definition
      complex_character = complex_character .. character
    else
      -- Regular character.
      array.push(result, character)
    end
  end

  return result
end

-- Produces a table used in creating a new keybinding.
function M:new()
  local result = {
    _cmd = '',
    _expr = '',
    _modes = {"n"},
    _silent = false,
    _noremap = false,
    _whichkey_text = nil,
    _aucmd_filetypes = nil
  }

  setmetatable(result, self)
  self.__index = self
  return result
end
-- Allow creation by calling the table directly as if it were a function.
-- 
-- Example:
-- local Binding = require("binding")
-- Binding():lcmd("fg"):expr("some command"):build()
M.__call = function() return M:new() end

--- Assign the command to execute when triggering the keybind.
function M:cmd(value)
  self._cmd = value
  return self
end

-- Assigns a command with the leader prefix assumed.
function M:lcmd(val)
  self._cmd = "<leader>" .. val
  return self
end

-- Mark command as being triggered for specific file type buffers only
function M:aufiles(val)
  self._aucmd_filetypes = val
  return self
end

-- Assign the keybind's sequence expression.
function M:expr(val)
  self._expr = val
  return self
end

-- Mark the keybind as being silent
function M:silent()
  self._silent = true
  return self
end

-- Mark the keybind as forbidding remapping.
function M:noremap()
  self._noremap = true
  return self
end

-- Set the modes this keybind should trigger in.
function M:modes(val)
  self._modes = val
  return self
end

function M:mode(val)
  self._modes = { val }
  return self
end

function M:help(val)
  self._whichkey_text = val
  return self
end


-- Registers the keybinding with vim-which-key.
function M:register_whichkey()
  local keys = split_keybind_string(self._cmd)
  local map_root = norwyn_which_key_map
  local keys_length = #keys

  for idx = 2, keys_length - 1 do
    map_root = map_root[keys[idx]]
  end

  map_root[keys[keys_length]] = self._whichkey_text
end

function M:_build_regular_binding()
  local edit_modes = { i = true, v = true }
  options = { silent = self._silent, noremap = self._noremap }

  for _, mode in ipairs(self._modes) do
    local sequence = ''
    if (edit_modes[mode]) then
      sequence = '<C-O>' .. self._expr
    else
      sequence = self._expr
    end

    vim.api.nvim_set_keymap(mode, self._cmd, sequence, options)

    -- If we have help text set, assume we can always bind with vim-which-key.
    -- TODO: Add guard checks around this, but honestly its probably fine without them.
  end

  if (self._whichkey_text ~= nil) then
    self:register_whichkey()
  end

end

local function build_aucmd_binding()
end

-- Finalize and assign the keybind to NeoVim.
function M:build()
  if (self._aucmd_filetypes) then
  else
    self:_build_regular_binding()
  end
end

return M
