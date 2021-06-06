local M = {}

local array = require("norwyn-vim.utilities.arrays")

-- Wrapper around quickly defining keybindings based on an appropriate file type
--
-- Example:
-- M.filetype_aucmd({ "rust" }, { "n", "i" } "<leader>bc", ":CargoCheck<CR>", { noremap = true, buffer = true, silent = true })
M.bind_filetype = function(filetypes, modes, keys, sequence, options)
  local edit_modes = { i = true, v = true }
  local edit_sequence = '<C-o>' .. sequence
  local prefixes = {}
  
  if (type(filetypes) == 'table') then filetypes = table.concat(filetypes, ',') end
  if (type(modes) == 'string') then modes = { modes } end
  
  if options['buffer'] then table.insert(prefixes, '<buffer>') end
  if options['silent'] then table.insert(prefixes, '<silent>') end
  prefixes = table.concat(prefixes, ' ')

  for _, mode in ipairs(modes) do
    if (options[noremap]) then mode = mode .. 'noremap' else mode = mode .. 'map' end
    local command_sequence = ''
    if (edit_modes[mode]) then command_sequence = edit_sequence else command_sequence = sequence end
    vim.api.nvim_command(string.format("au Filetype %s %s %s %s %s", filetypes, mode, prefixes, keys, command_sequence))
  end
end

return M
