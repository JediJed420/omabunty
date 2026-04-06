#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

info "Installing Audacity (free audio editor)..."

sudo apt update
sudo apt install -y audacity

mkdir -p "$HOME/.config/audacity"
mkdir -p "$BACKUP_DIR/audacity"

if [ -f "$HOME/.config/audacity/audacity.cfg" ]; then
    cp "$HOME/.config/audacity/audacity.cfg" "$BACKUP_DIR/audacity/audacity.cfg.bak"
fi

success "Audacity installed successfully!"
echo ""
echo "Audacity - Free alternative to Adobe Audition"
echo "  - Audio editing: https://www.audacityteam.org/"
echo "  - Run: audacity"
echo "  - Config: ~/.config/audacity/"
