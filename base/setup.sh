#!/bin/bash
set -Eeuo pipefail

source "${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/lib/common.sh"

# --- Rust toolchain (user-level, via rustup) ---
if ! has_command cargo && [[ ! -f "$HOME/.cargo/env" ]]; then
    log_info "Installing Rust toolchain via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
if [[ -f "$HOME/.cargo/env" ]]; then
    # shellcheck disable=SC1091
    source "$HOME/.cargo/env"
    log_ok "Rust toolchain available: $(cargo --version)"
fi

# --- mise (user-level, at ~/.local/bin/mise) ---
MISE_BIN="$HOME/.local/bin/mise"
if [[ ! -x "$MISE_BIN" ]]; then
    log_info "Installing mise..."
    curl -fsSL https://mise.run | sh
fi

log_info "Installing toolchains via mise (node, python, lua)..."
"$MISE_BIN" use --global node@22 python@3.13 lua@5.3
log_ok "mise toolchains: $("$MISE_BIN" ls --current | tr '\n' ' ')"

# --- Point luarocks at the mise-managed lua ---
if has_command luarocks; then
    if lua_dir="$("$MISE_BIN" where lua 2>/dev/null)"; then
        luarocks config --local lua_dir "$lua_dir"
        luarocks config --local lua_version 5.3
        log_ok "luarocks configured to use mise lua at $lua_dir"
    else
        log_warn "Could not resolve mise lua location; skipping luarocks configuration"
    fi
fi

# --- Shell rc wiring (all lines guarded, safe to re-run) ---
# shellcheck disable=SC2016  # $HOME must expand when the rc file is sourced, not here
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    ensure_rc_line "$rc" 'export PATH="$HOME/.local/bin:$PATH"'
    ensure_rc_line "$rc" 'export PATH="$HOME/.luarocks/bin:$PATH"'
    ensure_rc_line "$rc" '[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"'
done
# shellcheck disable=SC2016
ensure_rc_line "$HOME/.bashrc" 'eval "$($HOME/.local/bin/mise activate bash)"'
# shellcheck disable=SC2016
ensure_rc_line "$HOME/.zshrc"  'eval "$($HOME/.local/bin/mise activate zsh)"'

log_ok "Base setup complete"
