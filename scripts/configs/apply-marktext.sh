#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

install_marktext() {
    info "Installing Marktext (free markdown editor)..."
    
    if command -v flatpak &>/dev/null; then
        if ! flatpak list | grep -q "com.marktext.Marktext"; then
            info "Installing Marktext via Flatpak..."
            flatpak install -y flathub com.marktext.Marktext
        else
            info "Marktext already installed"
        fi
    else
        warn "Flatpak not found - installing snap instead..."
        sudo snap install marktext || {
            error "Failed to install Marktext"
            info "Manual install: https://github.com/marktext/marktext/releases"
        }
    fi
}

setup_config() {
    mkdir -p "$HOME/.config/marktext"
    mkdir -p "$BACKUP_DIR/marktext"
    
    if [ -f "$HOME/.config/marktext/config.json" ]; then
        cp "$HOME/.config/marktext/config.json" "$BACKUP_DIR/marktext/config.json.bak"
    fi
}

main() {
    install_marktext
    setup_config
    
    success "Marktext installed successfully!"
    echo ""
    echo "Marktext - Free alternative to Typora"
    echo "  - Markdown editor: https://marktext.app/"
    echo "  - Run: marktext or flatpak run com.marktext.Marktext"
    echo "  - Config: ~/.config/marktext/"
}

main "$@"