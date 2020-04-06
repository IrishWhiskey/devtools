#!/bin/bash

echo "tmux install"

#install tmux
if ! command -v tmux &>/dev/null; then
	apt install -y tmux
fi
