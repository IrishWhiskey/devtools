#!/bin/bash

apt update -y
apt install -y git curl build-essential xsel

apt install -y luarocks

curl https://sh.rustup.rs -sSf | sh -s -- -y
