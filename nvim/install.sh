#!/bin/bash

echo "nvim install"
apt install -y build-essential cmake python3-dev

sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt-get update -y

#install neovim
if ! command -v vim &>/dev/null; then
	apt install -y neovim
else
    apt remove -y vim
    apt install -y neovim
fi

#install ccls
sudo apt install -y snapd
snap install ccls --classic
