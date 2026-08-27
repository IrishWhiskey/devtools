#!/bin/bash
# Shared helpers for all devtools modules.
#
# Source from a module script with either:
#   source "${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/lib/common.sh"
# or just rely on DEVTOOLS_ROOT being exported by deploy.sh.

set -Eeuo pipefail

DEVTOOLS_ROOT="${DEVTOOLS_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export DEVTOOLS_ROOT

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
if [[ -t 1 ]]; then
    _RESET=$'\e[0m' _RED=$'\e[31m' _GREEN=$'\e[32m' _YELLOW=$'\e[33m' _BLUE=$'\e[36m'
else
    _RESET="" _RED="" _GREEN="" _YELLOW="" _BLUE=""
fi

log_info()  { printf '%s\n' "${_BLUE}[info]${_RESET} $*"; }
log_ok()    { printf '%s\n' "${_GREEN}[ok]${_RESET} $*"; }
log_warn()  { printf '%s\n' "${_YELLOW}[warn]${_RESET} $*"; }
log_error() { printf '%s\n' "${_RED}[error]${_RESET} $*" >&2; }
die()       { log_error "$@"; exit 1; }

# ---------------------------------------------------------------------------
# Platform detection: "macos", "ubuntu" (any apt-based distro), or "*-unsupported"
# ---------------------------------------------------------------------------
detect_platform() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if [[ -r /etc/os-release ]]; then
                # shellcheck disable=SC1091
                . /etc/os-release
                case " ${ID:-} ${ID_LIKE:-} " in
                    *ubuntu*|*debian*) echo "ubuntu" ;;
                    *)                 echo "linux-unsupported (${PRETTY_NAME:-unknown distro})" ;;
                esac
            else
                echo "linux-unsupported (no /etc/os-release)"
            fi
            ;;
        *)
            echo "unsupported ($(uname -s))"
            ;;
    esac
}

PLATFORM="$(detect_platform)"
export PLATFORM

# SUDO is a no-op prefix on macOS or when already root; "sudo" on Linux.
SUDO=""
if [[ "$PLATFORM" == "ubuntu" && $EUID -ne 0 ]]; then
    command -v sudo >/dev/null 2>&1 || die "sudo is required on Linux but was not found"
    SUDO="sudo"
fi
export SUDO

has_command() { command -v "$1" >/dev/null 2>&1; }

# ---------------------------------------------------------------------------
# Package management
# ---------------------------------------------------------------------------
ensure_brew() {
    has_command brew && return 0
    if [[ "$PLATFORM" != "macos" ]]; then
        die "ensure_brew called on non-macOS platform '$PLATFORM'"
    fi
    log_info "Homebrew not found; installing..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then
        # shellcheck disable=SC2046
        eval $(/opt/homebrew/bin/brew shellenv)
    elif [[ -x /usr/local/bin/brew ]]; then
        # shellcheck disable=SC2046
        eval $(/usr/local/bin/brew shellenv)
    fi
    has_command brew || die "Homebrew installation failed"
    log_ok "Homebrew installed"
}

# install_packages <pkg...> -- installs distro packages for the current platform
install_packages() {
    (( $# )) || return 0
    case "$PLATFORM" in
        ubuntu)
            $SUDO apt-get update -y
            $SUDO apt-get install -y "$@"
            ;;
        macos)
            ensure_brew
            brew install "$@"
            ;;
        *)
            die "install_packages: unsupported platform '$PLATFORM'"
            ;;
    esac
}

# ---------------------------------------------------------------------------
# Dotfile / config helpers (all idempotent)
# ---------------------------------------------------------------------------

# ensure_rc_line <rcfile> <line> -- append line to rcfile unless it already exists
ensure_rc_line() {
    local file="$1" line="$2"
    mkdir -p "$(dirname "$file")"
    touch "$file"
    if ! grep -qxF -- "$line" "$file"; then
        printf '%s\n' "$line" >> "$file"
        log_info "Added to $(basename "$file"): $line"
    fi
}

# backup_file <file> -- move an existing file aside with a timestamp suffix
backup_file() {
    local file="$1"
    [[ -e "$file" ]] || return 0
    local bak
    bak="${file}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$file" "$bak"
    log_warn "Backed up existing $file -> $bak"
}

# link_config <target> <link-path> -- symlink a config file, backing up any real file
link_config() {
    local target="$1" link="$2"
    mkdir -p "$(dirname "$link")"
    if [[ -L "$link" ]]; then
        rm "$link"
    elif [[ -e "$link" ]]; then
        backup_file "$link"
    fi
    ln -s "$target" "$link"
    log_ok "Linked $link -> $target"
}
