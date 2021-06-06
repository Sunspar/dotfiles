- proper file binding support for custom bind commands
    - we have plugin_loaded to check if vim-dispatch is present
    - We need a binding.bind_autocmd_string method that can just bind variable assignments on filetypes (eg: "au Filetype rust let b:dispatch = 'cargo build'")
- flesh out interface layer more

- improve binding system
    - autocommand wrappers for common events (pre-post buffer saving, entering buffers are the most common ones)

- vim-which-key setup
    - requires binding changes to plug through the keybinds and the messages

- finalize plugins for ruby, rust, elixir, typescript development