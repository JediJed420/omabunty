#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../colors.sh"

apply_plymouth_theme() {
    info "Applying Omabunty Plymouth theme..."
    
    if ! command -v plymouthd &>/dev/null; then
        warn "Plymouth not installed. Install with: sudo apt install plymouth"
        return 0
    fi
    
    local theme_dir="/usr/share/plymouth/themes/omabunty"
    local plymouth_conf="/etc/plymouth/plymouth.conf"
    
    info "Creating Omabunty Plymouth theme..."
    sudo mkdir -p "$theme_dir"
    
    sudo cp "$SCRIPT_DIR/../configs/plymouth/"* "$theme_dir/"
    
    sudo update-alternatives --install \
        /usr/share/plymouth/themes/default.plymouth \
        default.plymouth \
        "$theme_dir/omabunty.plymouth" \
        200
    
    sudo update-alternatives --set default.plymouth "$theme_dir/omabunty.plymouth"
    
    if command -v update-initramfs &>/dev/null; then
        info "Updating initramfs..."
        sudo update-initramfs -u
    fi
    
    success "Omabunty Plymouth theme applied!"
    echo ""
    echo "The new boot animation will appear on next reboot."
    echo ""
    echo "To preview without rebooting:"
    echo "  sudo plymouthd --debug && sudo plymouth --show-splash"
    echo "  # Press Ctrl+Alt+F1 to switch to console, Ctrl+C to quit"
    echo ""
    echo "To revert to default:"
    echo "  sudo update-alternatives --set default.plymouth /usr/share/plymouth/themes/buntu/buntu.plymouth"
    echo "  sudo update-initramfs -u"
}

apply_plymouth_theme
