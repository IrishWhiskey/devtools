#!/bin/bash

#install herdr
if ! sudo -H -u "$LOGIN_USER" sh -c 'command -v herdr &>/dev/null'; then
	curl -fsSL https://herdr.dev/install.sh | sudo -H -u "$LOGIN_USER" sh
fi
