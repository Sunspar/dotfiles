#!/usr/bin/env zsh

# Make sure we're always in zsh mode, not emulating bash or something.
emulate zsh

####################################################################################################
## System Profiling
####################################################################################################
$PROFILE_STARTUP=false
if [[ "${PROFILE_STARTUP}" == true ]]; then
   zmodload zsh/zprof
   PS4=$'%D{%M%S%.} %N:%i> '
   exec 3>&2 2>$HOME/startlog.$$
   setopt xtrace prompt_subst
fi

####################################################################################################
## Powerlevel10k - Instant Prompt
####################################################################################################
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
#[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
[ -f ~/.config/zsh/.p10k.zsh ] && source ~/.config/zsh/.p10k.zsh

####################################################################################################
## Functions
####################################################################################################
fpath=("${ZDOTDIR}/functions" $fpath)   && autoload ${ZDOTDIR}/functions/*
#fpath=("${ZDOTDIR}/prompts" $fpath)     && autoload ${ZDOTDIR}/prompts/*

####################################################################################################
## Setup - General
####################################################################################################
source "${ZDOTDIR}/aliases.zsh"
source "${ZDOTDIR}/exports.zsh"

# Use control+Arrow to skip around the line
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

####################################################################################################
## Runtime - Completions
####################################################################################################
# Load and initialize the completions and prompt systems
autoload -Uz compinit promptinit

# Load completions sytem ignoring insecure directories with a 20 hour cache timer.
# This ensures that it almost always regenerates the first time a shell is opened
# that day.
_comp_files=($XDG_CACHE_HOME/zsh/zcompcache(Nm-20))
if (( $#_comp_files )); then
    compinit -i -C -d "$XDG_CACHE_HOME/zsh/zcompcache"
else
    compinit -i -d "$XDG_CACHE_HOME/zsh/zcompcache"
fi
unset _comp_files
promptinit

setopt   prompt_subst
setopt   complete_in_word                    # Allow completions from both ends of the word
setopt   always_to_end                       # Move the cursor to the end of a completed word
setopt   path_dirs                           # Perform path search even on command names with slashes
setopt   auto_menu                           # Show completion menu when pressing tab
setopt   auto_list                           # Automatically list choices when completion is ambiguous
setopt   auto_param_slash                    # Add final slashes if completed param is a directory
unsetopt complete_aliases                    #
setopt   menu_complete                       # Don't autoselect the first completion entry
unsetopt flow_control                        # Disable start/stop chars in the editor
setopt   autocd                              # switch directories by typing the path

# Load colour support, because its the 21st century.
autoload -U colors && colors

# fix globbing rules
unsetopt case_glob                           # case-insensitive, because im not insane
setopt   globdots                            # grab dotfiles when globbing
setopt   extendedglob                        # Use extended globbing

# Smarter URL handling
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

####################################################################################################
## Background Jobs
####################################################################################################
setopt   long_list_jobs                      # List jobs in the longer format by default
setopt   auto_resume                         # Try to resume jobs before creating a new process
setopt   notify                              # Report status of background jobs immediately
unsetopt bg_nice                             # Dont run jobs at a lower priority
unsetopt hup                                 # Dont kill jobs when the shell exits
unsetopt check_jobs                          # Dont report on jobs when you close the shell

####################################################################################################
## ZStyle Configuration
####################################################################################################
zstyle ':completion:*:*:*:*:*'            menu             select
zstyle ':completion:*:matches'            group            'yes'
zstyle ':completion:*:options'            description      'yes'
zstyle ':completion:*:options'            auto-description '%d'
zstyle ':completion:*:corrections'        format           ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions'       format           ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages'           format           ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings'           format           ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default'            list-prompt      '%S%M matches%s'
zstyle ':completion:*'                    format           ' %F{yellow}-- %d --%f'
zstyle ':completion:*'                    group-name       ''
zstyle ':completion:*'                    verbose          yes
zstyle ':completion::complete:*'          cache-path       "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion::complete:*'          use-cache        on
zstyle ':completion:*'                    list-colors      ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors      '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*'                    matcher-list     'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions'          ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*'                    rehash           true
zmodload zsh/complist

####################################################################################################
## History
####################################################################################################
HISTFILE="${ZDOTDIR}/history"                # Where to store the history
HISTSIZE=1000000                             # Size of the history cache
SAVEHIST=1000000                             #

setopt   appendhistory notify                #

unsetopt beep nomatch                        # Dont beep when you have no matches
setopt   bang_hist                           # Treat the bang specially during expansion
setopt   inc_append_history                  # Write to history file immediately
setopt   share_history                       # Share history across all terminals
setopt   hist_expire_dups_first              # Dont store events that were just recorded
setopt   hist_ignore_all_dups                # Delete old recorded events if a new event is a duplicate
setopt   hist_find_no_dups                   # Don't display previously found events
setopt   hist_ignore_space                   # Dont record events starting with space
setopt   hist_save_no_dups                   # Don't write duplicate events to the history file
setopt   hist_verify                         # Don't execute immediately upon expansion
setopt   extended_history                    # Show timestamps in the history log

####################################################################################################
# FZF Support
####################################################################################################
if [[ -d /usr/share/fzf ]]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
fi

####################################################################################################
## Plugins
####################################################################################################
source "${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme"

####################################################################################################
## Others - Unsorted
####################################################################################################
setopt combining_chars                       # Combine zero-width accent characters with the base character
setopt brace_ccl                             # Allow brace character class list expansion
setopt rc_quotes                             # 'Stuff 'like' this',  not 'Stuff \'like\' this'
setopt correct                               # Enable corrections
setopt beep                                  # beep when commands are finished


# ASDF, the verison manager for most of my tooling
if [[ -s "$HOME/.asdf/asdf.sh" ]]; then
    # source "$HOME/.asdf/asdf.sh"
    source $HOME/.asdf/lib/asdf.sh
fi

# TODO: edit-command-line support zsh


####################################################################################################
## Disable startup tracing if enabled
####################################################################################################
if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
    zprof > ~/zshprofile$(date +'%s')
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
