#! /usr/bin/env zsh

fix_resolv_conf() {
    # For some reason gpg just blows up if you dont add something in /etc/resolv.conf, despite not actually using
    # resolvconf for anything else. Looks like the culprit is gpg possibly reading the file directly, because of
    # course we're still using individualized DNS resolution in 2021.
    #
    # For more reading, see: https://unix.stackexchange.com/a/630182
    rm /etc/resolv.conf
    ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
}

install_packages() {
    source "install-packages.zsh"
}

setup_zsh_as_shell() {
    chsh -s $(command -v zsh)
}

install_asdf() {
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
}

install_asdf_plugins() {
    source "install-asdf-plugins.zsh"
}

# Ask for sudo password up front, and then cache it so we dont have to reauth during the script.
# See: https://gist.github.com/cowbow/3118588
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &

fix_resolv_conf
install_packages
install_asdf
setup_zsh_as_shell
install_asdf_plugins