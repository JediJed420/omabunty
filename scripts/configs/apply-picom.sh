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

install_picom() {
    info "Installing Picom compositor..."
    
    sudo apt update
    sudo apt install -y picom
}

setup_configs() {
    info "Setting up Picom configuration..."
    
    mkdir -p "$HOME/.config"
    
    cat > "$HOME/.config/picom.conf" << 'EOF'
# Picom configuration for Omabunty

backend = "glx";
glx-no-stencil = true;
use-damage = true;
vsync = true;

# Transparency
active-opacity = 1;
inactive-opacity = 1;
frame-opacity = 1;
shadow = true;
shadow-opacity = 0.6;
shadow-radius = 15;
shadow-offset-x = 0;
shadow-offset-y = 5;

# Blur
blur-method = "dual_kawase";
blur-size = 7;
blur-strength = 3;

# Exclusions
wintypes:
{
    tooltip = { fade = true; };
    dock = { shadow = false; };
    dnd = { shadow = false; };
    fullscreen = { shadow = false; };
};

# Window rules
shadow-exclude = [
    "class_g = 'waybar'",
    "class_g = 'docklike'",
    "name = 'Notification'",
    "name = 'tray'"
];

# Fading
fade-in = true;
fade-out = true;
fade-duration = 200;
no-fading-openclose = true;
no-fading-destroyed-argb = true;

# Exclude specific windows
opacity-rule = [
    "80:class_g = 'Alacritty'",
    "80:class_g = 'kitty'"
];
EOF
    
    success "Picom configuration installed to ~/.config/picom.conf"
}

main() {
    install_picom
    setup_configs
    info "Picom setup complete!"
}

main "$@"