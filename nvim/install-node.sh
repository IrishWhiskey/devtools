#!/bin/bash

. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc

if [[ -z "${NVM_DIR}" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
fi

nvm install node
