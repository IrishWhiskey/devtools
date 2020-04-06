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

#install plugins
vim -es -u $HOME/.vimrc -i NONE -c "PlugInstall" -c "qa"

#install YouCompleteMe
if ! [[ -f $HOME/.vim/cpp_installed ]]; then
    $HOME/.vim/plugged/YouCompleteMe/install.py --clang-completer
    touch $HOME/.vim/cpp_installed
fi
