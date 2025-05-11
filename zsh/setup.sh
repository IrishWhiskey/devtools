#!/bin/bash

#install oh-my-zsh
if ! [[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/} ]]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

#install autosuggestions
if ! [[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

#link .zshrc
DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "source $DIR/zshrc" >> $HOME/.zshrc
