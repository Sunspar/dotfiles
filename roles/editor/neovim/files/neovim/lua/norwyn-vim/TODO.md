- "UI"
  - Main UI layer with sublayers for everything?
  - seperate layers under a "UI" panel?
  - top level layers because otherwise everything kind of just gets shoved into "UI" somehow?
    - If we splut what would the actual separation be?
    - Languages at least makes sense because youd be picking a subset based on the langs you work with
    - Maybe best to just have layers.debugger, layers.intellisense, etc
    - Can branch out after if you want to support multiple "alternatives" or something
    - "Core" really doesnt need as much as it currently has
   

    - languages: typescript, html, css, scss, javascript, elixir, erlang, php, yaml
    - frameworks: vuejs, phoenix? other stuff?, helm, ansible

    Flesh out:
    - debugging with vimspector
    - intellisense with coc (can we set up auto-injections or something)
  - Probably want some sort of intelligent installation pricess
    - run PlugInstall
    - run any coc requirements if coc is enabled? 

