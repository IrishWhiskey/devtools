#!/bin/bash
set -Eeuo pipefail

source "${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/lib/common.sh"

# Remove distro packages (best-effort, in case a packaged neovim is present)
if has_command apt-get; then
    $SUDO apt-get remove -y neovim vim > /dev/null 2>&1 || true
elif has_command dnf; then
    $SUDO dnf remove -y neovim vim > /dev/null 2>&1 || true
elif has_command pacman; then
    $SUDO pacman -Rns --noconfirm neovim vim > /dev/null 2>&1 || true
fi

if [[ "$PLATFORM" == "macos" ]] && has_command brew; then
    brew uninstall -f neovim vim > /dev/null 2>&1 || true
fi

# Remove our user-level install (tarball layout + config symlink + data dirs)
rm -rf "$HOME/.local/opt/nvim"
rm -f  "$HOME/.local/bin/nvim" "$HOME/.local/bin/vim"
rm -rf "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"
rm -rf "$HOME/.config/nvim"

log_ok "neovim removed"
