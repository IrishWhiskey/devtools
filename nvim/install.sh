#!/bin/bash
set -Eeuo pipefail

source "${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/lib/common.sh"

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_VERSION="${NVIM_VERSION:-v0.11.1}"

# Clean up any previous install first
bash "$MODULE_DIR/remove.sh" || log_warn "Pre-install cleanup reported issues; continuing"

case "$PLATFORM" in
    macos)
        install_packages neovim
        ;;
    ubuntu)
        case "$(uname -m)" in
            x86_64)      arch="x86_64" ;;
            aarch64|arm64) arch="arm64" ;;
            *)           die "Unsupported architecture for neovim: $(uname -m)" ;;
        esac

        url="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-${arch}.tar.gz"
        tmp="$(mktemp -d)"

        log_info "Downloading neovim ${NVIM_VERSION} (${arch})..."
        curl -fsSL "$url" | tar -xzf - -C "$tmp"

        mkdir -p "$HOME/.local/opt" "$HOME/.local/bin"
        rm -rf "$HOME/.local/opt/nvim"
        mv "$tmp/nvim-linux-${arch}" "$HOME/.local/opt/nvim"
        rm -rf "$tmp"

        ln -sfn "$HOME/.local/opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"
        ln -sfn "$HOME/.local/bin/nvim" "$HOME/.local/bin/vim"
        ;;
    *)
        die "nvim module does not support platform '$PLATFORM'"
        ;;
esac

export PATH="$HOME/.local/bin:$PATH"
log_ok "neovim installed: $(nvim --version | head -n1)"
