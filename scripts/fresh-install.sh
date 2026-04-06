#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

BACKUP_DIR="$HOME/.omabunty-backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

backup_configs() {
    info "Backing up existing configurations..."
    mkdir -p "$BACKUP_DIR/$TIMESTAMP"
    
    local configs=(
        "$HOME/.config/hypr"
        "$HOME/.config/waybar"
        "$HOME/.config/alacritty"
        "$HOME/.config/kitty"
        "$HOME/.config/rofi"
        "$HOME/.config/picom"
        "$HOME/.config/neovim"
        "$HOME/.config/aether"
        "$HOME/.config/sddm"
    )
    
    for cfg in "${configs[@]}"; do
        if [[ -d "$cfg" ]]; then
            cp -r "$cfg" "$BACKUP_DIR/$TIMESTAMP/"
            success "Backed up: $cfg"
        fi
    done
    
    if [[ -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.zshrc" "$BACKUP_DIR/$TIMESTAMP/"
        success "Backed up: .zshrc"
    fi
    
    info "Backup complete: $BACKUP_DIR/$TIMESTAMP"
}

install_deps() {
    info "Installing dependencies..."
    
    if ! command -v apt-get &>/dev/null; then
        error "apt-get not found. This script requires Ubuntu/Debian."
        exit 1
    fi
    
    sudo apt-get update
    sudo apt-get install -y \
        git curl wget zsh neovim \
        build-essential cmake pkg-config libssl-dev \
        wayland hyprland waybar wofi rofi \
        alacritty kitty \
        picom btop \
        sddm wlogout \
        snapd 2>/dev/null || true
    
    success "Dependencies installed"
}

install_omabunty() {
    info "Installing Omabunty configuration..."
    
    cd "$SCRIPT_DIR/.."
    
    for script in scripts/configs/*.sh; do
        if [[ -f "$script" ]]; then
            info "Applying: $(basename "$script")"
            bash "$script" || warn "Failed: $(basename "$script")"
        fi
    done
    
    success "Omabunty configuration applied"
}

setup_zsh() {
    info "Setting up Zsh with Oh My Zsh..."
    
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    if [[ -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.pre-omabunty"
    fi
    
    success "Zsh configured"
}

post_install() {
    info "Running post-install tasks..."
    
    if command -v systemctl &>/dev/null; then
        sudo systemctl enable sddm 2>/dev/null || true
    fi
    
    success "Post-install complete"
}

main() {
    info "Starting Omabunty fresh installation..."
    
    backup_configs
    install_deps
    setup_zsh
    install_omabunty
    post_install
    
    success "Installation complete! Please restart your system."
}

main "$@"