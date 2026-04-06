#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }

install_waybar() {
    info "Installing Waybar and dependencies..."
    
    sudo apt update
    sudo apt install -y \
        waybar \
        libgtk-3-0 \
        libpulse0 \
        libnl-3-1 \
        libnl-genl-3-1 \
        rfkill
}

setup_configs() {
    info "Setting up Waybar configuration..."
    
    mkdir -p "$HOME/.config/waybar"
    
    if [[ -f "$SCRIPT_DIR/../configs/waybar/config.jsonc" ]]; then
        cp "$SCRIPT_DIR/../configs/waybar/config.jsonc" "$HOME/.config/waybar/config"
    fi
    
    if [[ -f "$SCRIPT_DIR/../configs/waybar/style.css" ]]; then
        cp "$SCRIPT_DIR/../configs/waybar/style.css" "$HOME/.config/waybar/style.css"
    fi
    
    success "Waybar configuration installed to ~/.config/waybar/"
}

main() {
    install_waybar
    setup_configs
    info "Waybar setup complete!"
}

main "$@"