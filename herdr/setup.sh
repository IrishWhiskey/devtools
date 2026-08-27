#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"

mkdir -p "$HOME/.config/herdr"

if [ -e "$HOME/.config/herdr/config.toml" ] && [ ! -L "$HOME/.config/herdr/config.toml" ]; then
	mv "$HOME/.config/herdr/config.toml" "$HOME/.config/herdr/config.toml.bak"
fi

ln -sf "$DIR/config.toml" "$HOME/.config/herdr/config.toml"

if command -v herdr &>/dev/null; then
	herdr server reload-config &>/dev/null
fi
