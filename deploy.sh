#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGIN_USER=$(logname)

export LOCAL_HOME=$(sudo -H -u $LOGIN_USER bash -c 'echo $HOME')

run_scripts_for_dir() {
    local dir="$1"

    if [ -f "$dir/install.sh" ]; then
        echo "Running $dir/install.sh as root..."
        "$dir/install.sh"
    fi

    if [ -f "$dir/setup.sh" ]; then
        echo "Running $dir/setup.sh as $LOGIN_USER..."
        sudo -u "$LOGIN_USER" "$dir/setup.sh"
    fi
}

DEPENDENCY_ORDER=(
    "base"
    "zsh"
    "tmux"
    "nvim"
)

for dependency in "${DEPENDENCY_ORDER[@]}"; do
    dir="$SCRIPT_DIR/$dependency"
    if [ -d "$dir" ]; then
        echo "Processing dependency: $dependency"
        run_scripts_for_dir "$dir"
    else
        echo "Warning: Dependency directory not found: $dependency"
    fi
done

echo "Processing any remaining directories..."
for dir in "$SCRIPT_DIR"/*/ ; do
    if [ -d "$dir" ]; then
        dirname=$(basename "$dir")

        if [[ " ${DEPENDENCY_ORDER[*]} " == *" $dirname "* ]]; then
            continue
        fi

        echo "Processing additional directory: $dirname"
        run_scripts_for_dir "$dir"
    fi
done

if command -v zsh &> /dev/null; then
    echo "Changing shell to zsh..."
    chsh -s $(which zsh)
else
    echo "zsh is not installed, cannot change shell"
fi

echo "Deployment complete!"
