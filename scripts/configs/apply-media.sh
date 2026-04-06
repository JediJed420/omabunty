#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

install_mpv() {
    info "Installing mpv (free media player)..."
    
    sudo apt update
    sudo apt install -y mpv
}

install_imv() {
    info "Installing imv (free image viewer)..."
    
    sudo apt install -y imv libcurl4-gnutls-dev libSDL2-2.0-0 libgif-dev libjpeg-dev libpango1.0-dev libpng-dev
}

setup_configs() {
    mkdir -p "$HOME/.config/mpv"
    mkdir -p "$HOME/.config/imv"
    mkdir -p "$BACKUP_DIR/mpv"
    mkdir -p "$BACKUP_DIR/imv"
}

main() {
    install_mpv
    install_imv
    setup_configs
    
    success "Media apps installed successfully!"
    echo ""
    echo "mpv - Free video player (VLC alternative)"
    echo "  - Run: mpv"
    echo ""
    echo "imv - Free image viewer"
    echo "  - Run: imv"
}

main "$@"