# Set global editors and interactive apps
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export BROWSER="open"

# Make sure we're using UTF8
if [[ -z "$LANG" ]]; then
    export LANG="en_US.UTF-8"
fi

# Derfine the system path manually, so that its stable across environments.
#
# This process requries two passes, due to limitations in how ASDF locates dependent software.
# In the first pass, we load the bare minimum requried for any asdf related shims to work.
# Once those paths are set, we can re-load $PATH with the correct full set, and when ASDF-installed
# software requires other asdf-installed software it can correctly locaate it because the shims and bin
# folders are "already" in the path.
export path=(
    ${HOME}/.asdf/shims
    ${HOME}/.asdf/bin
    /usr/bin
)

export path=(
    # allow ZSH binaries and scripts highest priority
    ${ZDOTDIR}/bin
    ${HOME}/.terminal/bin
    # Load ASDF related software next, which ensures we use ASDF-provided items, even when the names conflict
    # with system-installed software
    ${HOME}/.asdf/shims
    ${HOME}/.asdf/bin
    $(yarn global bin)
    # Flutter reqires the android SDK, which is installed here.
    /opt/android-sdk/emulator
    /opt/android-sdk/tools
    /opt/android-sdk/platform-tools
    # Regrettably, some software is installed via snap packages and so we load the Snap bin folder to facilitate
    # easily loading these pieces of software.
    /var/lib/snapd/snap/bin
    # Finally, we load the typical UNIX/Linux well-known paths so that OS level programs continue to function as expected.
    /usr/local/bin
    /usr/local/sbin
    /usr/bin
)
