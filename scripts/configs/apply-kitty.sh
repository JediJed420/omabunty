#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

info "Applying Kitty config..."

mkdir -p "$HOME/.config/kitty"
mkdir -p "$BACKUP_DIR/kitty"

if [ -f "$HOME/.config/kitty/kitty.conf" ]; then
    cp "$HOME/.config/kitty/kitty.conf" "$BACKUP_DIR/kitty/kitty.conf.bak"
fi

OMARCHY_THEME="$HOME/.config/omarchy/current/theme/kitty.conf"
AETHER_THEME="$HOME/.config/aether/theme/kitty.conf"

if [ -f "$OMARCHY_THEME" ]; then
    cat > "$HOME/.config/kitty/kitty.conf" << EOF
# Omabunty Kitty Configuration
# Theme sourced from Omarchy

include $OMARCHY_THEME

# Terminal settings
term xterm-256color

# Font configuration
font_size 9
font_family "JetBrainsMono Nerd Font"

# Window settings
window_padding_width 14
hide_window_decorations yes

# Performance
repaint_delay 10
input_delay 3
sync_to_monitor yes
EOF
    success "Kitty config applied from Omarchy theme!"
elif [ -f "$AETHER_THEME" ]; then
    cat > "$HOME/.config/kitty/kitty.conf" << EOF
# Omabunty Kitty Configuration
# Theme sourced from Aether

include $AETHER_THEME

# Terminal settings
term xterm-256color

# Font configuration
font_size 9
font_family "JetBrainsMono Nerd Font"

# Window settings
window_padding_width 14
hide_window_decorations yes

# Performance
repaint_delay 10
input_delay 3
sync_to_monitor yes
EOF
    success "Kitty config applied from Aether theme!"
else
    error "No theme found! Run 'aether --generate <wallpaper>' first."
    exit 1
fi