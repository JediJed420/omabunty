#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

install_btop() {
    info "Installing btop (free system monitor)..."
    
    sudo apt update
    sudo apt install -y btop
}

setup_config() {
    mkdir -p "$HOME/.config/btop"
    mkdir -p "$BACKUP_DIR/btop"
    
    if [ -f "$HOME/.config/btop/btop.conf" ]; then
        cp "$HOME/.config/btop/btop.conf" "$BACKUP_DIR/btop/btop.conf.bak"
    fi
    
    cp "$SCRIPT_DIR/../../config/btop/btop.conf" "$HOME/.config/btop/btop.conf"
}

main() {
    install_btop
    setup_config
    
    success "btop installed successfully!"
    echo ""
    echo "btop - Free alternative to Activity Monitor"
    echo "  - System monitor: https://github.com/aristocratos/btop"
    echo "  - Run: btop"
    echo "  - Config: ~/.config/btop/"
}

main "$@"