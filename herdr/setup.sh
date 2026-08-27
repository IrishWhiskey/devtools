#!/bin/bash
set -Eeuo pipefail

source "${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/lib/common.sh"

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_config "$MODULE_DIR/config.toml" "$HOME/.config/herdr/config.toml"

if has_command herdr; then
    herdr server reload-config > /dev/null 2>&1 || true
fi

log_ok "herdr setup complete"
