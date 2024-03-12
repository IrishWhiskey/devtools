#!/bin/bash

install_nvim() {
    wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
    chmod +x nvim.appimage
    cp nvim.appimage /usr/local/bin/nvim
    ln -s /usr/local/bin/nvim /usr/local/bin/vim
}

echo "nvim install"

# uninstall vim if present
if command -v vim &>/dev/null; then
    apt remove -y vim
fi

(cd /tmp; install_nvim)
