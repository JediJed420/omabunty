#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

BACKUP_DIR="$HOME/.omabunty-backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

pre_upgrade_backup() {
    info "Creating pre-upgrade backup..."
    mkdir -p "$BACKUP_DIR/$TIMESTAMP"
    
    local dirs=(
        "$HOME/.config"
        "$HOME/.local/share"
        "$HOME/.oh-my-zsh"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            cp -r "$dir" "$BACKUP_DIR/$TIMESTAMP/"
        fi
    done
    
    if [[ -f "/etc/apt/sources.list" ]]; then
        sudo cp /etc/apt/sources.list "$BACKUP_DIR/$TIMESTAMP/sources.list"
    fi
    
    success "Pre-upgrade backup complete: $BACKUP_DIR/$TIMESTAMP"
}

update_ubuntu() {
    info "Updating Ubuntu packages..."
    
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
    
    success "Ubuntu packages updated"
}

install_omabunty() {
    info "Installing Omabunty packages..."
    
    cd "$SCRIPT_DIR/.."
    
    for script in scripts/configs/*.sh; do
        if [[ -f "$script" ]]; then
            info "Applying: $(basename "$script")"
            bash "$script" || warn "Failed: $(basename "$script")"
        fi
    done
    
    success "Omabunty configuration applied"
}

cleanup_old() {
    info "Cleaning up old packages..."
    
    sudo apt-get autoremove -y
    sudo apt-get autoclean
    
    success "Cleanup complete"
}

main() {
    if [[ "$EUID" -eq 0 ]]; then
        error "Do not run as root. Run as regular user with sudo access."
        exit 1
    fi
    
    info "Starting Omabunty upgrade..."
    
    pre_upgrade_backup
    update_ubuntu
    install_omabunty
    cleanup_old
    
    success "Upgrade complete! Please restart your system."
}

main "$@"