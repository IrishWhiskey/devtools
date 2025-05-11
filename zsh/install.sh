#!/bin/bash

#install zsh
if ! command -v zsh &>/dev/null; then
	apt install -y zsh
fi
