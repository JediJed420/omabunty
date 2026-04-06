#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/colors.sh"

create_launcher() {
    info "Creating Omabunty Menu launcher..."
    
    mkdir -p "$HOME/.local/share/applications"
    mkdir -p "$HOME/.local/share/omabunty/bin"
    mkdir -p "$HOME/.local/share/omabunty/scripts"
    
    cat > "$HOME/.local/share/applications/omabunty-menu.desktop" << 'EOF'
[Desktop Entry]
Name=Omabunty Menu
Comment=Omabunty Application Menu
Exec=bash -c "$HOME/omabunty/scripts/omarchy-menu"
Icon=system-run
Terminal=false
Type=Application
Categories=System;
EOF
    
    cp "$SCRIPT_DIR/omarchy-menu" "$HOME/.local/share/omabunty/scripts/"
    cp "$SCRIPT_DIR/omabunty-install-system-deps" "$HOME/.local/share/omabunty/scripts/"
    
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    
    success "Menu launcher created!"
    echo ""
    echo "You can now launch the Omabunty Menu:"
    echo "  1. From terminal: omabunty-menu"
    echo "  2. From application launcher (Super key): 'Omabunty Menu'"
    echo "  3. Bind to a key in Hyprland"
}

main() {
    create_launcher
}

main "$@"