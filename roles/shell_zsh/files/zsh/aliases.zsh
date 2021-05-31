# Easier navigation
# Technically autocd means ~ and .. aliases arent necessary, but for consistency's sake
# theyre included anyway.
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias d="dirs -v"

# Enable aliases to also be sudoed
alias sudo='sudo '

# Manage dotfiles with a bare repo
alias dotfiles="$(command -v git) --git-dir=/home/sunspar/workspace/sunspar/dotfiles --work-tree=${HOME}"

# Network
alias whois='whois -h whois-servers.net'
alias wtfismyip='dig +short myip.opendns.com @resolver1.opendns.com'
alias ip='ip --color=auto'

# Easily reload ZSH config after changing it
alias reload='exec zsh -l'

# Power
alias quit='exit'
alias poweroff='systemctl poweroff'
alias reboot='systemctl reboot'
alias sleep='systemctl suspend'

alias map='xargs -n1'
alias pgrep='pgrep -fli'

# TermBin -- toss command output onto termbin.com for easy sharing\
alias tb='nc termbin.com 9999'

# Reload dotfiles, overwriting anything that currently exists!
alias df-reload="ansible-playbook --ask-become-pass ${HOME}/workspace/sunspar/dotfiles-playbook/main.yaml"