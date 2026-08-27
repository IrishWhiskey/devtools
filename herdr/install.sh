#!/bin/bash
set -Eeuo pipefail

source "${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/lib/common.sh"

if ! has_command herdr; then
    log_info "Installing herdr..."
    curl -fsSL https://herdr.dev/install.sh | sh
fi

log_ok "herdr available at $(command -v herdr)"
