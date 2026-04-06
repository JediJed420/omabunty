#!/bin/bash
set -euo pipefail

# Omabunty Main Installer
# Install all core components

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

info "Installing Omabunty..."

# Install dependencies
info "Installing system dependencies..."
bash "$SCRIPT_DIR/install-deps.sh"

# Install core configs
info "Installing Hyprland..."
bash "$SCRIPT_DIR/configs/apply-hyprland.sh"

info "Installing SDDM..."
bash "$SCRIPT_DIR/configs/apply-sddm.sh"

info "Installing Waybar..."
bash "$SCRIPT_DIR/configs/apply-waybar.sh"

info "Installing Terminals..."
bash "$SCRIPT_DIR/configs/apply-terminals.sh"

info "Installing Rofi..."
bash "$SCRIPT_DIR/configs/apply-rofi.sh"

info "Installing Zsh..."
bash "$SCRIPT_DIR/configs/apply-zsh.sh"

info "Installing LazyVim..."
bash "$SCRIPT_DIR/configs/apply-lazyvim.sh"

info "Installing Picom..."
bash "$SCRIPT_DIR/configs/apply-picom.sh"

# Install menu system
info "Installing Menu System..."
bash "$SCRIPT_DIR/install-menu.sh"

success "Omabunty installation complete!"
echo ""
echo "Next steps:"
echo "  1. Reboot and select SDDM (Hyprland session)"
echo "  2. Press Super+M to open the Omabunty Menu"
echo "  3. Run 'nvim' to complete LazyVim setup"