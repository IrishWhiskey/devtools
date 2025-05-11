#!/bin/bash

rm -rf $HOME/.zshrc
touch $HOME/.zshrc

rm -rf $HOME/.bashrc
touch $HOME/.bashrc

MISE=$HOME/.local/bin/mise

export PATH="$HOME/.local/bin:$PATH"

$MISE use --global node@22 python@3.13 lua@5.3

MISE_LUA_PATH=$($MISE where lua)
if [ -n "$MISE_LUA_PATH" ]; then
    luarocks config --local lua_dir "$MISE_LUA_PATH"
    luarocks config --local lua_version 5.3
fi

# Create mise activation script
cat > $HOME/.mise-activate.sh << 'EOF'
# Add mise to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Activate mise in the current shell
if [ -f "$HOME/.local/bin/mise" ]; then
    eval "$($HOME/.local/bin/mise activate bash)"
fi
EOF

chmod +x $HOME/.mise-activate.sh

# Add mise activation to shell startup files
for rcfile in $HOME/.bashrc $HOME/.zshrc; do
    if [ -f "$rcfile" ]; then
        if ! grep -q "source \$HOME/.mise-activate.sh" "$rcfile"; then
            echo "source \$HOME/.mise-activate.sh" >> "$rcfile"
        fi
    fi
done

# Setup mise to load automatically in shells
$MISE hook-env > $HOME/.mise-hook.sh
chmod +x $HOME/.mise-hook.sh

for rcfile in $HOME/.bashrc $HOME/.zshrc; do
    if [ -f "$rcfile" ]; then
        if ! grep -q "source \$HOME/.mise-hook.sh" "$rcfile"; then
            echo "source \$HOME/.mise-hook.sh" >> "$rcfile"
        fi
    fi
done

# Add luarocks bin to PATH
mkdir -p $HOME/.luarocks
if ! grep -q 'export PATH="$HOME/.luarocks/bin:$PATH"' $HOME/.bashrc; then
    echo 'export PATH="$HOME/.luarocks/bin:$PATH"' >> $HOME/.bashrc
fi
if ! grep -q 'export PATH="$HOME/.luarocks/bin:$PATH"' $HOME/.zshrc; then
    echo 'export PATH="$HOME/.luarocks/bin:$PATH"' >> $HOME/.zshrc
fi
