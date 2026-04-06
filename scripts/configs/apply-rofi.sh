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

install_rofi() {
    info "Installing Rofi/Wofi..."
    
    sudo apt update
    sudo apt install -y rofi wofi
}

setup_configs() {
    info "Setting up Rofi/Wofi configuration..."
    
    mkdir -p "$HOME/.config/rofi"
    mkdir -p "$HOME/.config/wofi"
    
    cat > "$HOME/.config/rofi/config.rasi" << 'EOF'
configuration {
    modi: "drun,run";
    display-drun: "Applications";
    display-run: "Run";
    drun-display-format: "{name}";
    font: "JetBrainsMono Nerd Font 12";
    show-icons: true;
    icon-theme: "Papirus";
    location: 0;
    width: 600;
    height: 400;
    x-offset: 0;
    y-offset: 0;
}

* {
    background-color: #1f1f28;
    color: #dcd7ba;
    border: 0;
    border-radius: 8px;
}

#window {
    background-color: rgba(31, 31, 40, 0.95);
    border: 1px solid #dcd7ba;
    border-radius: 12px;
    padding: 10px;
}

#input {
    background-color: #1f1f28;
    border: none;
    padding: 10px;
    color: #dcd7ba;
}

#entry:selected {
    background-color: #7e9cd8;
    color: #1f1f28;
}

#textbox {
    background-color: #1f1f28;
    color: #dcd7ba;
}
EOF

    cat > "$HOME/.config/wofi/config" << 'EOF'
width=600
height=400
location=center
show=drun
prompt=Search...
filter_rate=100
allow_markup=true
no_actions=true
halign=fill
orientation=vertical
content_halign=fill
exec_search=false
image_size=32
gtk_dark=true
EOF

    cat > "$HOME/.config/wofi/style.css" << 'EOF'
window {
    background-color: #1f1f28;
    color: #dcd7ba;
    border-radius: 12px;
    border: 1px solid #dcd7ba;
}

#input {
    background-color: #1f1f28;
    color: #dcd7ba;
    border: none;
    padding: 10px;
}

#entry:selected {
    background-color: #7e9cd8;
    color: #1f1f28;
}
EOF
    
    success "Rofi/Wofi configuration installed!"
}

main() {
    install_rofi
    setup_configs
    info "Rofi/Wofi setup complete!"
}

main "$@"