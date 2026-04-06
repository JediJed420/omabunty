#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/../configs"

source "$SCRIPT_DIR/../colors.sh"

info "Applying terminal configs..."

# Apply Alacritty config
if command -v alacritty &> /dev/null; then
    info "Applying Alacritty config..."
    bash "$CONFIG_DIR/apply-alacritty.sh"
else
    warn "Alacritty not installed, skipping..."
fi

# Apply Kitty config
if command -v kitty &> /dev/null; then
    info "Applying Kitty config..."
    bash "$CONFIG_DIR/apply-kitty.sh"
else
    warn "Kitty not installed, skipping..."
fi

# Apply Zsh config
if command -v zsh &> /dev/null; then
    info "Applying Zsh config..."
    bash "$CONFIG_DIR/apply-zsh.sh"
else
    warn "Zsh not installed, skipping..."
fi

success "Terminal configs applied successfully!"