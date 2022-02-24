#! /usr/bin/env bash

# Sunspar's Dotfiles and environment setup scripts.
#
# This script determines the desired playbook, and then executes it, bootstrapping ansible if required.
# Currently we only support macOS as thats my main machine, although adding linux distro support should
# be relatively straightforward -- differences would mostly be the source folders for config files and
# differences in package management.

# Arg $1 determines what base playbook to run.
local playbook=$1

# On MacOS, we need homebrew at a minimum. Install it if we cannot find it on the system.
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Bootstrap ansible if the expected binaries dont exist.
if ! command -v ansible-playbook &> /dev/null; then
  brew install ansible
fi

# Run Ansible!
ansible-galaxy collection install community.general
ansible-playbook -i inventory dotfiles-playbook/main.yml