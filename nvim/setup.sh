#!/bin/bash
set -Eeuo pipefail

source "${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/lib/common.sh"

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- jupytext (prefer mise-managed python; fall back to system pip) ---
export PATH="$HOME/.local/bin:$PATH"
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
