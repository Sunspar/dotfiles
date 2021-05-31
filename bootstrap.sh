#! /usr/bin/env bash

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -fr yay

yay -S ansible

# A small portion of our config changes require sudo, so we must ask for the password up front
ansible-playbook main.yaml --ask-become-pass