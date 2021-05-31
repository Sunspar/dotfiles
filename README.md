# Dotfiles

## Post-setup

### Setup credentials for spotifyd
Spotifyd uses the gnome-keyring but we'll need to set the password up first for it to be useful:
```sh
secret-tool store --label='spotifyd account password' application rust-keyring service spotifyd username <your username in the config file>
```