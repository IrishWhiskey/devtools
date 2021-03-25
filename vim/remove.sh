#!/bin/bash

echo "vim remove"

rm -rf /home/$(logname)/.vim*
rm -rf /home/$(logname)/.config/coc

#remove vim
if command -v vim &>/dev/null; then
	apt remove -y vim
	apt autoremove -y
fi
