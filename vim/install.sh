#!/bin/bash

echo "vim setup"
apt install -y build-essential cmake python3-dev

#install vim
if ! command -v vim &>/dev/null; then
	apt install -y vim
fi
