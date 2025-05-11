#!/bin/bash

apt update -y
apt install -y git curl build-essential xsel

curl https://mise.run | sh

apt install -y luarocks
