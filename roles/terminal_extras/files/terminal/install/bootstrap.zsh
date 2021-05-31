#! /usr/bin/env zsh

# Really small script that simply sets up the dotfiles repo, clones it down, and installs it into the user's $HOME.
# We use a "bare" repo, so the folder structure that is seen within git mimics the files and folders that are
# installed, rooted at $HOME.
#
# We essentially install the dotfiles and bootstrap a machine in three stages:
# - clone the repo and check it out, applying our files into $HOME
# - Run install-packages.zsh, which bootstraps the machine with Yay (AUR Helper), runs package installations, etc
# - Run post-install.zsh, which performs one-time work 

dotfiles_path="${HOME}/workspace/sunspar/test"
dotfiles_repo="git@github.com:Sunspar/dotfiles.git"
alias dotfiles="$(command -v git) --git-dir=${dotfiles_path} --work-tree=${HOME}"
alias reload='exec zsh -l'
mkdir -p "${dotfiles_path}"
git clone --bare ${dotfiles_repo} "${dotfiles_path}"
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
reload