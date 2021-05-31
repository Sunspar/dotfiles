local norwyn = require("norwyn-vim")

norwyn({
  bundle_path = "~/.config/nvim/bundle",
  layers      = {
    ansible       = { },
    colors        = { theme = "nord" },
    core          = { leaderkey = "," },
    csv           = { },
    dart          = { },
    debugger      = { },
    elixir        = { }, 
    git           = { },
    graphql       = { },
    helm          = { },
    html          = { },
    intellisense  = { },
    interface     = { },
    javascript    = { },
    keybind_help  = { disable_floating_win = true },
    lua           = { },
    markdown      = { },
    nix           = { },
    ruby          = { },
    rust          = { },
    search        = { },
    testing       = { },
    typescript    = { },
    vuejs         = { },
  } 
})
