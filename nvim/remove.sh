#!/bin/bash

echo "nvim remove"

OS=$(uname -s)
if [[ "$OS" == "Linux" ]]; then
    OS_version=$(uname -v)

    if [[ "$OS_version" == *"Ubuntu"* ]]; then
        apt-get remove -y neovim vim
    elif [[ "$OS_version" == *"Debian"* ]]; then
        apt-get remove -y neovim vim
    elif [[ "$OS_version" == *"CentOS"* ]]; then
        yum remove -y neovim vim
    elif [[ "$OS_version" == *"RHEL"* ]]; then
        yum remove -y neovim vim
    elif [[ "$OS_version" == *"Fedora"* ]]; then
        dnf remove -y neovim vim
    elif [[ "$OS_version" == *"Arch"* ]]; then
        pacman -Rn neovim vim
    else
        echo "Unknown OS version"
    fi

    rm -f /usr/local/bin/vim
    rm -f /usr/local/bin/nvim
    rm -rf /home/$(logname)/.config/nvim
elif [[ "$OS" == "Darwin" ]]; then
    brew uninstall -y neovim vim
else
    echo "Unknown OS"
fi
