#!/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DEVTOOLS_ROOT="$SCRIPT_DIR"

# shellcheck source=lib/common.sh
source "$DEVTOOLS_ROOT/lib/common.sh"

trap 'log_error "Deployment failed while running: ${BASH_COMMAND} (deploy.sh line $LINENO)"' ERR

ALLOW_ROOT="${DEVTOOLS_ALLOW_ROOT:-0}"
for arg in "$@"; do
    case "$arg" in
        --allow-root) ALLOW_ROOT=1 ;;
        *)            die "Unknown argument: $arg (usage: ./deploy.sh [--allow-root])" ;;
    esac
done

if [[ $EUID -eq 0 ]]; then
    if [[ "$ALLOW_ROOT" != "1" ]]; then
        die "Run this script as your normal user, not root. sudo is used internally only where needed. Override with --allow-root or DEVTOOLS_ALLOW_ROOT=1."
    fi
    log_warn "Running as root (--allow-root); user-level setup will target root's home directory"
fi

log_info "Platform: $PLATFORM"

if [[ -n "$SUDO" ]]; then
    $SUDO -v || die "sudo authentication is required on Linux for package installation"
fi

# Modules run in dependency order; anything else in the repo root runs after.
MODULES_ORDER=(base zsh herdr nvim)

run_module_scripts() {
    local dir="$1" name
    name="$(basename "$dir")"
    if [[ -f "$dir/install.sh" ]]; then
        log_info "[$name] install.sh (system-level; may use sudo)"
        bash "$dir/install.sh"
    fi
    if [[ -f "$dir/setup.sh" ]]; then
        log_info "[$name] setup.sh (user-level)"
        bash "$dir/setup.sh"
    fi
}

completed=""
for module in "${MODULES_ORDER[@]}"; do
    dir="$DEVTOOLS_ROOT/$module"
    if [[ ! -d "$dir" ]]; then
        log_warn "Module directory not found: $module (skipping)"
        continue
    fi
    log_info "===== Module: $module ====="
    run_module_scripts "$dir"
    completed="$completed $module "
done

log_info "Processing any remaining module directories..."
for dir in "$DEVTOOLS_ROOT"/*/; do
    [[ -d "$dir" ]] || continue
    name="$(basename "$dir")"
    [[ " $completed " == *" $name "* ]] && continue
    [[ "$name" == "lib" ]] && continue
    log_info "===== Additional module: $name ====="
    run_module_scripts "$dir"
done

# Make zsh the login shell (for the invoking user, not root)
if [[ "${SHELL:-}" == *zsh ]]; then
    log_ok "Login shell is already zsh"
else
    zsh_path="$(command -v zsh || true)"
    if [[ -z "$zsh_path" ]]; then
        log_warn "zsh not found; login shell not changed"
    elif [[ "$PLATFORM" == "macos" ]]; then
        log_info "Setting login shell to zsh (may prompt for your password)..."
        chsh -s /bin/zsh
        log_ok "Login shell set to zsh"
    else
        $SUDO chsh -s "$zsh_path" "$USER"
        log_ok "Login shell set to zsh"
    fi
fi

log_ok "Deployment complete!"
