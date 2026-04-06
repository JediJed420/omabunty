#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

install_fastfetch() {
    info "Installing fastfetch (system info display)..."
    
    sudo apt update
    sudo apt install -y fastfetch
}

setup_config() {
    mkdir -p "$HOME/.config/fastfetch"
    mkdir -p "$BACKUP_DIR/fastfetch"
    
    if [ -f "$HOME/.config/fastfetch/config.jsonc" ]; then
        cp "$HOME/.config/fastfetch/config.jsonc" "$BACKUP_DIR/fastfetch/config.jsonc.bak"
    fi
    
    cp "$SCRIPT_DIR/../../config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
}

main() {
    install_fastfetch
    setup_config
    
    success "fastfetch installed successfully!"
    echo ""
    echo "fastfetch - System info display tool"
    echo "  - Run: fastfetch"
    echo "  - Config: ~/.config/fastfetch/"
}

main "$@"