#!/bin/bash

echo "tmux setup"

DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "source $DIR/tmux.conf" > $HOME/.tmux.conf
