#!/bin/bash

echo "vim setup"

#create undodir
if ! [[ -d $HOME/.vim/undodir ]]; then
	mkdir -p $HOME/.vim/undodir
fi

#install plug
if ! [[ -f $HOME/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

#link .vimrc
DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "source $DIR/vimrc" > $HOME/.vimrc

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
vim -es -u $HOME/.vimrc -i NONE -c "PlugInstall" -c "qa"
vim -es -u $HOME/.vimrc -i NONE -c "CocInstall" -c "qa"

# copy coc preferences
cp ./coc-settings.json $HOME/.vim/coc-settings.json

# copy coc snippets
mkdir -p $HOME/.config/coc/ultisnips
cp -r ultisnips/* $HOME/.config/coc/ultisnips
