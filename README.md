# Dotfiles

## Post-setup

### Setup credentials for spotifyd
Spotifyd uses the gnome-keyring but we'll need to set the password up first for it to be useful:
```sh
secret-tool store --label='spotifyd account password' application rust-keyring service spotifyd username <your username in the config file>
```

### OpenVPN Connection
Grab the openvpn config file and run the following:
```sh
nmcli connection import type openvpn file <path to openvpn config file>

nmcli connection modify <connection name> vpn.user-name <vpn username>
```

And then it can be started with `nmtui` by providing the password.