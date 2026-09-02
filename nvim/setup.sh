#!/bin/bash
set -Eeuo pipefail

if (( EUID == 0 )); then
    printf '%s\n' "[error] Run nvim/setup.sh as your regular user, not with sudo." >&2
    exit 1
fi

source "${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/lib/common.sh"

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# nvim-treesitter builds parsers below stdpath("cache"). Repair stale cache
# directories left behind if Neovim or this setup was previously run with sudo.
NVIM_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"
if [[ -d "$NVIM_CACHE_DIR" ]] \
    && find "$NVIM_CACHE_DIR" -maxdepth 1 -type d -name 'tree-sitter-*' \
        ! -uid "$(id -u)" -print -quit | grep -q .; then
    has_command sudo || die "Root-owned Tree-sitter caches found in $NVIM_CACHE_DIR; sudo is required to repair them"
    log_warn "Repairing ownership of stale Tree-sitter caches in $NVIM_CACHE_DIR"
    sudo find "$NVIM_CACHE_DIR" -maxdepth 1 -type d -name 'tree-sitter-*' \
        ! -uid "$(id -u)" -exec chown -R "$(id -u):$(id -g)" '{}' +
fi

export PATH="$HOME/.local/bin:$PATH"

# nvim-treesitter's main branch uses the Tree-sitter CLI to compile parsers.
if ! has_command tree-sitter; then
    case "$PLATFORM" in
        macos)
            install_packages tree-sitter-cli
            ;;
        *)
            if [[ -x "$HOME/.local/bin/mise" ]]; then
                "$HOME/.local/bin/mise" exec -- npm install --global tree-sitter-cli
            elif has_command npm; then
                npm install --global --prefix "$HOME/.local" tree-sitter-cli
            else
                die "tree-sitter CLI is required; install tree-sitter-cli and rerun setup"
            fi
            ;;
    esac
fi

# --- jupytext (prefer mise-managed python; fall back to system pip) ---
if [[ -x "$HOME/.local/bin/mise" ]]; then
    "$HOME/.local/bin/mise" exec -- pip install jupytext \
        || pip3 install jupytext \
        || log_warn "jupytext installation failed; continuing"
else
    pip3 install jupytext || log_warn "jupytext installation failed; continuing"
fi

# --- Config: symlink the repo config so `git pull` updates it ---
link_config "$MODULE_DIR/config" "$HOME/.config/nvim"

log_ok "nvim setup complete"
