#!/bin/bash

echo "nvim remove"

rm -rf /home/$(logname)/.config/nvim

#remove neovim
if command -v nvim &>/dev/null; then
	apt remove -y neovim
    apt autoremove -y
fi
