#!/bin/bash

echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc

mkdir -p $HOME/.luarocks
echo 'export PATH="$HOME/.luarocks/bin:$PATH"' >> $HOME/.bashrc
echo 'export PATH="$HOME/.luarocks/bin:$PATH"' >> $HOME/.zshrc
