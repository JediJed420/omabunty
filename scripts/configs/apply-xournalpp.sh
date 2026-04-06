#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

install_xournalpp() {
    info "Installing Xournal++ (free note-taking app)..."
    
    sudo apt update
    sudo apt install -y xournalpp
}

setup_config() {
    mkdir -p "$HOME/.config/xournalpp"
    mkdir -p "$BACKUP_DIR/xournalpp"
    
    if [ -f "$HOME/.config/xournalpp/settings.xml" ]; then
        cp "$HOME/.config/xournalpp/settings.xml" "$BACKUP_DIR/xournalpp/settings.xml.bak"
    fi
    
    cp "$SCRIPT_DIR/../../config/xournalpp/settings.xml" "$HOME/.config/xournalpp/settings.xml"
}

main() {
    install_xournalpp
    setup_config
    
    success "Xournal++ installed successfully!"
    echo ""
    echo "Xournal++ - Free note-taking app (GoodNotes/Notability alternative)"
    echo "  - Run: xournalpp"
    echo "  - Config: ~/.config/xournalpp/"
}

main "$@"