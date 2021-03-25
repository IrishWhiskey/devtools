#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

zsh/install.sh
tmux/install.sh
nvim/install.sh
sudo -u $(logname) zsh/setup.sh
sudo -u $(logname) tmux/setup.sh
sudo -u $(logname) nvim/setup.sh

chsh -s $(which zsh)
