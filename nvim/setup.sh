#!/bin/bash

echo "nvim setup"

DIR="$( cd "$( dirname "$0" )" && pwd )"
# install node (used by nvim extensions)
sudo -u $(logname) $DIR/install-node.sh

# create undodir
if ! [[ -d $HOME/.config/nvim/undodir ]]; then
	mkdir -p $HOME/.config/nvim/undodir
fi

# install plug
if ! [[ -f $HOME/.config/nvim/autoload/plug.vim ]]; then
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

#link .vimrc
echo "source $DIR/vimrc" > $HOME/.config/nvim/init.vim

# install nerd-fonts
if ! [[ -f $HOME/.fonts/symbols-1000-nerd-font.ttf ]]; then
    curl -LJ0 https://github.com/ryanoasis/nerd-fonts/blob/master/src/glyphs/Symbols-1000-em%20Nerd%20Font%20Complete.ttf\?raw\=true > symbols-1000-nerd-font.ttf

    if ! [[ -d $HOME/.fonts ]]; then
        mkdir $HOME/.fonts
    fi
    mv symbols-1000-nerd-font.ttf $HOME/.fonts/symbols-1000-nerd-font.ttf
    fc-cache -fv
fi

#install plugins
nvim -es -u $HOME/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"
nvim -es -u $HOME/.config/nvim/init.vim -i NONE -c "CocInstall" -c "qa"

# copy coc preferences
cp $DIR/coc-settings.json $HOME/.config/nvim/coc-settings.json

# copy coc snippets
mkdir -p $HOME/.config/coc/ultisnips
cp -r $DIR/ultisnips/* $HOME/.config/coc/ultisnips
