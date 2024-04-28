#!/bin/bash

echo "nvim setup"

DIR="$( cd "$( dirname "$0" )" && pwd )"

cp -rf ${DIR}/config/* ${HOME}/.config/nvim
