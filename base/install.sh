#!/bin/bash
set -Eeuo pipefail

source "${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/lib/common.sh"

case "$PLATFORM" in
    ubuntu)
        install_packages git curl build-essential xsel luarocks
        ;;
    macos)
        # clang/build tools come with Xcode CLT via Homebrew; xsel is macOS-native (pbcopy)
        install_packages luarocks
        has_command git || install_packages git
        ;;
    *)
        die "base module does not support platform '$PLATFORM'"
        ;;
esac

log_ok "Base packages installed"
