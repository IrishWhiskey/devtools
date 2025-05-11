#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "source $DIR/tmux.conf" > $HOME/.tmux.conf
