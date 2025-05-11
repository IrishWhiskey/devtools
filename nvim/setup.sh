#!/bin/bash

pip3 install jupytext

DIR="$( cd "$( dirname "$0" )" && pwd )"

TARGET_DIR=${HOME}/.config/nvim

mkdir -p ${TARGET_DIR}
cp -rf ${DIR}/config/* ${TARGET_DIR}
