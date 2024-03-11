#!/bin/bash

echo "nvim remove"

rm -rf /home/$(logname)/.config/nvim

# remove neovim
rm -f /usr/local/bin/vim
rm -f /usr/local/bin/nvim
