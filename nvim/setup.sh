#!/bin/bash

echo "nvim setup"

DIR="$( cd "$( dirname "$0" )" && pwd )"

cp -r ${DIR}/config ${HOME}/.config/nvim
