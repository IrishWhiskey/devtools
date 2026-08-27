#!/bin/bash
set -Eeuo pipefail

source "${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/lib/common.sh"

# macOS ships zsh; on Ubuntu install via apt
has_command zsh || install_packages zsh

log_ok "zsh available at $(command -v zsh)"
