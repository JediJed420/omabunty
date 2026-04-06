#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../colors.sh"

install_sddm() {
    info "Installing SDDM..."
    
    sudo apt-get update
    sudo apt-get install -y sddm sddm-theme-breeze
    
    sudo systemctl enable sddm
}

apply_sddm_config() {
    info "Applying SDDM configuration..."
    
    mkdir -p "$HOME/.config/sddm"
    cp "$SCRIPT_DIR/../configs/sddm/sddm.conf" "$HOME/.config/sddm/"
    
    if [[ -d /etc/sddm.conf.d ]]; then
        sudo cp "$SCRIPT_DIR/../configs/sddm/sddm.conf" /etc/sddm.conf.d/omabunty.conf
    fi
    
    success "SDDM config applied"
}

main() {
    install_sddm
    apply_sddm_config
}

main "$@"
