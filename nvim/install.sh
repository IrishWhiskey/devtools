#!/bin/bash

echo "nvim install"
apt install -y build-essential cmake python3-dev

#install neovim
if ! command -v vim &>/dev/null; then
	apt install -y neovim
else
    apt remove -y vim
    apt install -y neovim
fi
