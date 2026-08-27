#!/bin/bash
set -Eeuo pipefail

source "${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/lib/common.sh"

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM_DIR="$ZSH_DIR/custom"

# --- oh-my-zsh (unattended: no chsh, no zsh launch, keep existing zshrc) ---
if [[ ! -d "$ZSH_DIR" ]]; then
    log_info "Installing oh-my-zsh..."
    RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null
fi

# --- zsh-autosuggestions plugin ---
if [[ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]]; then
    log_info "Installing zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" > /dev/null
fi

# --- Source our zshrc from ~/.zshrc ---
ensure_rc_line "$HOME/.zshrc" "source \"$MODULE_DIR/zshrc\""

log_ok "zsh setup complete"
