#!/bin/bash

apt update -y
apt install -y git curl build-essential

curl https://mise.run | sh

apt install -y luarocks
