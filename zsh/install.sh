#!/bin/bash

echo "zsh install"

apt install git curl

#install zsh
if ! command -v zsh &>/dev/null; then
	apt install -y zsh
fi
