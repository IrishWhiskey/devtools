#!/bin/bash

apt update -y
apt install -y git curl build-essential

curl https://mise.run | sh
MISE=$HOME/.local/bin/mise

$MISE use --global node@22 python@3.13 lua@5.3

apt install -y luarocks

MISE_LUA_PATH=$($MISE where lua)
if [ -n "$MISE_LUA_PATH" ]; then
    luarocks config --local lua_dir "$MISE_LUA_PATH"
    luarocks config --local lua_version 5.3
fi
