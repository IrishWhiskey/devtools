#!/bin/bash

linux_install() {
    wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    chmod +x nvim.appimage
    cp nvim.appimage /usr/local/bin/nvim
    ln -s /usr/local/bin/nvim /usr/local/bin/vim
}

osx_install() {
    sudo -u $(logname) brew install neovim
}

# uninstall if present
(./remove.sh)

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
