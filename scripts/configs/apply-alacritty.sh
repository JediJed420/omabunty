#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

info "Applying Alacritty config..."

mkdir -p "$HOME/.config/alacritty"
mkdir -p "$BACKUP_DIR/alacritty"

if [ -f "$HOME/.config/alacritty/alacritty.toml" ]; then
    cp "$HOME/.config/alacritty/alacritty.toml" "$BACKUP_DIR/alacritty/alacritty.toml.bak"
fi

OMARCHY_THEME="$HOME/.config/omarchy/current/theme/alacritty.toml"
AETHER_THEME="$HOME/.config/aether/theme/alacritty.toml"

if [ -f "$OMARCHY_THEME" ]; then
    cat > "$HOME/.config/alacritty/alacritty.toml" << EOF
import = [ "$OMARCHY_THEME" ]

[env]
TERM = "xterm-256color"

[terminal]
osc52 = "CopyPaste"

[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
bold = { family = "JetBrainsMono Nerd Font", style = "Bold" }
italic = { family = "JetBrainsMono Nerd Font", style = "Italic" }
size = 9

[window]
padding.x = 14
padding.y = 14
decorations = "None"

[keyboard]
bindings = [
    { key = "Insert", mods = "Shift", action = "Paste" },
    { key = "Insert", mods = "Control", action = "Copy" },
    { key = "Return", mods = "Shift", chars = "\u001B\r" }
]
EOF
    success "Alacritty config applied from Omarchy theme!"
elif [ -f "$AETHER_THEME" ]; then
    cat > "$HOME/.config/alacritty/alacritty.toml" << EOF
import = [ "$AETHER_THEME" ]

[env]
TERM = "xterm-256color"

[terminal]
osc52 = "CopyPaste"

[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
bold = { family = "JetBrainsMono Nerd Font", style = "Bold" }
italic = { family = "JetBrainsMono Nerd Font", style = "Italic" }
size = 9

[window]
padding.x = 14
padding.y = 14
decorations = "None"

[keyboard]
bindings = [
    { key = "Insert", mods = "Shift", action = "Paste" },
    { key = "Insert", mods = "Control", action = "Copy" },
    { key = "Return", mods = "Shift", chars = "\u001B\r" }
]
EOF
    success "Alacritty config applied from Aether theme!"
else
    error "No theme found! Run 'aether --generate <wallpaper>' first."
    exit 1
fi