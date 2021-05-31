# Build out the list of packages we should install. These will be installed with yay, so you can mix both official repository packages
# and stuff from the AUR here.

pkgs=(
### X11
    awesome-git                 # Awesome Window Manager. Need the source builds for some newer features.
    picom                       # Compton fork that doesnt suck
    rofi                        # app launcher
    lm_sensors                  # Sensor management for temps, fan speeds, etc
    xorg-xrandr                 # Display management
    arandr                      # GUI management for displays
    xorg-server                 # Xorg display server
    xorg-xwininfo               # CLI for X server window information
    xorg-xinit                  # Xorg initialization program
    xorg-xprop                  # Property displayer for X
    xorg-xdpyinfo               # Display information utility for X
    xorg-xbacklight             # RandR-based backlight control for X
    xorg-xsetroot               # Lets us configure the cursor for X
    xclip                       # CLI for the X11 clipboard
    xdotool                     # CLI X11 automation tool
    xwallpaper                  # Wallpaper setting utility for X
    xdg-utils                   # Provides xdg-open and friends (You'll want to symlink this to something like /usr/local/bin/open)

### NVIDIA Support for GPUs
#    nvidia                      # Proprietary nvidia drivers
#    nvidia-settings             # nvidia configuration application

### Chat/Collaboration apps
    discord-canary              # The beta version of Discord. meta package is just 'discord'
    slack-desktop               # slack client for linux

### Web browsers
    firefox                     # Firefox browser
    google-chrome               # Chrome browser

### General *nix tools
    gparted                     # partition manager
    htop                        # Improved system resource management from a terminal

### Android development (mostly for flutter support)
    jdk-openjdk                 # Java development kit
    android-sdk                 # Android development toolkit
    android-sdk-build-tools     # build tools for android SDK
    android-sdk-build-tools     #
    android-sdk-platform-tools  #
    android-emulator            #
    android-platform            #

### Fonts
    ttf-font-awesome            #
    ttf-anonymous-pro           #
    noto-fonts                  #
    adobe-source-code-pro-fonts #
    ttf-inconsolata             #
    ttf-linux-libertine         #
    ttf-unifont                 #

### Media
    pulseaudio                  #
    pulseaudio-alsa             #
    pulsemixer                  #
    alsa-utils                  #
    mpv                         #
    spotify                     #

### Filesystem Management
    exfat-utils                 # exFAT filesystem support
    ntfs-3g                     # NTFS filesystem support
    trash-cli                   # command-line trash/recycle bin support
    thunar                      # Graphical file management

### Containerization
    iptables                    # firewalls and shit
    docker                      # what if we virtualized the virtualization layer?

### Laptop Management
    # lm_sensors                  # system thermals
    # tlp                         #
    # tlp-rdw                     #

### Databases
    mongodb-bin                 # NoSQL database server
    mongodb-tools-bin           # client-side MongoDB tooling
    mongodb-compass             # GUI interface for working with MongoDB
    mariadb                     # MySQL-compatible alternative
    postgresql                  # PostgreSQL database server software

### Unsorted
    plymouth                    # Splash screen functionality on boot
    feh                         # CLI based wallpaper tool
    sddm                        # simple desktop manager (login screen)
    nnn                         # Really lightweight terminal file browser
    neovim                      # text editor based on vim
    openvpn                     # OpenVPN client
    gnu-netcat                  # Provides GNU's NetCat util. (alternatively: openbsd-netcat
    kitty                       # terminal emulator
    1password-cli               # 1Password CLI tool
    visual-studio-code-bin      # The official VS Code builds from MS
    obs-studio                  # Screencast/streaming software
    emacs                       # The operating system with a text editor included!
    gnome-keyring               #
    fzf                         # The #1 fuzzy finder
    highlight                   #
    task-spooler                #
    neofetch                    #
    wrk                         # api/website stress-testing
    wget                        #
    curl                        #
    flameshot

### Wayland
    # wofi                        # Wayland Launcher (Rofi but without having to run it via XWayland)
    # wdisplays-git               # GUI controls for display management on wayland compositors
    # kanshi-git                  # Automatic monitor management for wayland
    # mako                        # Notifications for wayland
    # sway-git                    # Sway window manager
    # wlroots-git                 # 
    # waybar-git                  # Programmable statusbar for wayland
    # swaylock-effects-git        # swaylock fork with some cooler effects (lockscreen for wayland)
    # grim                        # screenshot tool
    # slurp                       # screen selection tool
    # swappy-git                  # post-screenshot markup tool
    
### Ops Tools
    lens-bin                        # The Kubernetes IDE
    remmina                         # Remote Desktop
)

# Set up GPG keys we need to install
gpg_keys=(
    3FEF9748469ADBE15DA7CA80AC2D62742012EA22 # 1Password CLI
)



# If we dont find the yay command, we'll need to build it and install it first in order to install packages later.
# You could swap this out for your AUR helper of choice but if you aren't sure I'd recommend just using Yay.
if ! command -v yay > /dev/null 2>&1
then
    git clone https://aur.archlinux.org/yay.git \
        && cd yay \
        && makepkg -si \
        && cd .. \
        && rm -fr yay
fi

gpg --recv-keys ${gpg_keys}
yay -S ${pkgs}