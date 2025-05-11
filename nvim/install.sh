#!/bin/bash

linux_install() {
    wget https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.appimage -O nvim.appimage
    chmod +x nvim.appimage
    cp nvim.appimage /usr/local/bin/nvim
    ln -s /usr/local/bin/nvim /usr/local/bin/vim
}

osx_install() {
    sudo -u $(logname) brew install neovim
}

# uninstall if present
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
"$SCRIPT_DIR/remove.sh"

echo "nvim install"

OS=$(uname -s)
if [[ "$OS" == "Linux" ]]; then
    HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
    (cd /tmp; linux_install)
elif [[ "$OS" == "Darwin" ]]; then
    osx_install
else
    echo "Unknown OS"
fi
