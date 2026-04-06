#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../colors.sh"

install_systemd_user_services() {
    info "Installing systemd user services..."
    
    mkdir -p "$HOME/.config/systemd/user"
    
    cp "$SCRIPT_DIR/../../config/systemd/user/omabunty-battery-monitor.service" "$HOME/.config/systemd/user/"
    cp "$SCRIPT_DIR/../../config/systemd/user/omabunty-battery-monitor.timer" "$HOME/.config/systemd/user/"
    
    systemctl --user daemon-reload
    systemctl --user enable --now omabunty-battery-monitor.timer
    
    success "Systemd user services installed"
}

install_systemd_user_services
