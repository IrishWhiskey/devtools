#!/bin/bash

. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc

if [[ -z "${NVM_DIR}" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
fi

echo 'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> $HOME/.zshrc

nvm install 16.4.0
nvm use v16.4.0
