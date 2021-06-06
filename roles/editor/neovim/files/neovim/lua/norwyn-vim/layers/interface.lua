-- UI - Vim, but with F  L  A  I  R

-- My highly oppinionated base UI. Feel free to yank and replace as always.
local M = {}

local helpers = require("norwyn-vim.config.helpers")
local plugin_loaded = helpers.plugin_loaded
local layer_loaded = helpers.layer_loaded
local keybind = require("norwyn-vim.config.keybind")


local function set_keybinds()
  -----------------------------------------------------------------------------
  -- NERDTree
  -----------------------------------------------------------------------------
  -- Toggle nerd tree
  keybind:new():cmd("<C-T>"):expr(":NERDTreeToggle<CR>"):noremap():modes({"n", "i", "v"}):build()

  -----------------------------------------------------------------------------
  -- Generic
  -----------------------------------------------------------------------------
  -- vim-which-key: <leader>b - Buffer Management
  norwyn_which_key_map["b"] = { name = "+buffers" }

  -- Kill current buffer
  keybind:new():lcmd("bd"):expr(":bd<CR>"):noremap():help("delete buffer"):build()
  -- Kill current buffer, with force
  keybind:new():lcmd("bD"):expr(":bd!<CR>"):noremap():help("[!] delete buffer"):build()
  -- Create vertical split, and spawn new buffer
  keybind:new():lcmd("bv"):expr(":vsplit<CR>"):noremap():help("spawn vertical buffer"):build()
  -- Create horizontal split, and spawn new buffer
  keybind:new():lcmd("bh"):expr(":split<CR>"):noremap():help("spawn horizontal buffer"):build()
  -- List current buffers
  keybind:new():lcmd("bb"):expr(":buffers<CR>"):noremap():help("list current buffers"):build()
  -- Save current buffer
  keybind:new():cmd("<C-S>"):expr(":w<CR>"):silent():noremap():modes({"n","i","v", "x"}):build()

  -- Code commenting
  keybind:new():cmd("<C-C>"):expr(":Commentary<CR>"):noremap():help("Comment/Uncomment text"):build()
  keybind:new():cmd("<C-C>"):expr(":'<,'>Commentary<CR>"):mode("x"):noremap():help("Comment/Uncomment text"):build()
end

local function set_variables()
  -----------------------------------------------------------------------------
  -- Airline
  -----------------------------------------------------------------------------
  -- fonts for things like arrows and icons
  vim.g.airline_powerline_fonts                     = 1

  -- Top line for buffers
  vim.g["airline#extensions#tabline#enabled"]       = 1
  vim.g["airline#extensions#tabline#left_sep"]      = " "
  vim.g["airline#extensions#tabline#left_alt_sep"]  = "|"
  
  -----------------------------------------------------------------------------
  -- NERDTree
  -----------------------------------------------------------------------------
  vim.g.WebDevIconsUnicodeDecorateFolderNodes           = 1
  vim.g.WebDevIconsUnicodeDecorateFolderNodes           = 1
  vim.g.DevIconsEnableFoldersOpenClose                  = 1
  vim.g.DevIconsEnableFolderExtensionPatternMatching    = 1
  vim.g.NERDTreeShowHidden                              = 1
  vim.g.NERDTreeGitStatusIndicatorMapCustom             = {
    Clean       = "✔︎",
    Deleted     = "✖",
    Dirty       = "✗",
    Ignored     = "☒",
    Modified    = "✹",
    Renamed     = "➜",
    Staged      = "✚",
    Unknown     = "?",
    Unmerged    = "═",
    Untracked   = "✭"
  }

  -----------------------------------------------------------------------------
  -- Generic
  -----------------------------------------------------------------------------
  --vim.o.nocompatible    = true
end

function M.plugins(opts)
  return { 
    -- Airline alternative
    ["vim-airline/vim-airline"]     = { },
    -- File browser
    ["scrooloose/nerdtree"]         = { },
    -- Git status symbols in nerdtree
    ["Xuyuanp/nerdtree-git-plugin"] = { },
    -- Free range, grain-fed developer file icons
    ["ryanoasis/vim-devicons"]      = { },
    -- Commenting support for multiple languages
    ["tpope/vim-commentary"]        = { },
  }
end

function M.pre_config(opts)
end

function M.config(opts)
  set_variables()
  set_keybinds()
end

function M.post_config(opts)
end

return M
