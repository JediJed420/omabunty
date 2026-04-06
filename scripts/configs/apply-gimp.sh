#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

info "Installing GIMP (free image editor)..."

sudo apt update
sudo apt install -y gimp

mkdir -p "$HOME/.config/GIMP"

success "GIMP installed successfully!"
echo ""
echo "GIMP - Free alternative to Adobe Photoshop"
echo "  - Image editing: https://www.gimp.org/"
echo "  - Run: gimp"
echo "  - Config: ~/.config/GIMP/"
