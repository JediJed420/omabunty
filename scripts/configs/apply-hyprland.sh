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

install_hyprland() {
    info "Installing Hyprland and related packages..."
    
    sudo apt update
    sudo apt install -y \
        hyprland \
        hypridle \
        hyprlock \
        hyprpaper \
        hyprsunset \
        hyprpicker \
        wl-clipboard \
        cliphist \
        grim \
        slurp \
        wlogout
}

setup_configs() {
    info "Setting up Hyprland configuration..."
    
    mkdir -p "$HOME/.config/hypr/defaults"
    
    if [[ -f "$SCRIPT_DIR/../configs/hypr/hyprland.conf" ]]; then
        cp "$SCRIPT_DIR/../configs/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
    fi
    
    if [[ -f "$SCRIPT_DIR/../configs/hypr/defaults.conf" ]]; then
        cp "$SCRIPT_DIR/../configs/hypr/defaults.conf" "$HOME/.config/hypr/defaults/monitors.conf"
        cp "$SCRIPT_DIR/../configs/hypr/defaults.conf" "$HOME/.config/hypr/defaults/envs.conf"
        cp "$SCRIPT_DIR/../configs/hypr/defaults.conf" "$HOME/.config/hypr/defaults/input.conf"
        cp "$SCRIPT_DIR/../configs/hypr/defaults.conf" "$HOME/.config/hypr/defaults/looknfeel.conf"
        cp "$SCRIPT_DIR/../configs/hypr/defaults.conf" "$HOME/.config/hypr/defaults/windows.conf"
    fi
    
    if [[ -f "$SCRIPT_DIR/../configs/hypr/bindings.conf" ]]; then
        cp "$SCRIPT_DIR/../configs/hypr/bindings.conf" "$HOME/.config/hypr/bindings.conf"
    fi
    
    if [[ -f "$SCRIPT_DIR/../configs/hypr/autostart.conf" ]]; then
        cp "$SCRIPT_DIR/../configs/hypr/autostart.conf" "$HOME/.config/hypr/autostart.conf"
    fi
    
    success "Hyprland configuration installed to ~/.config/hypr/"
}

main() {
    install_hyprland
    setup_configs
    info "Hyprland setup complete!"
    info "Log out and select Hyprland from SDDM to start using Omabunty."
}

main "$@"