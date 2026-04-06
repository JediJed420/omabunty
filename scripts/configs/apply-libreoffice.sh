#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

info "Installing LibreOffice (free office suite)..."

sudo apt update
sudo apt install -y libreoffice libreoffice-gnome libreoffice-gtk3

mkdir -p "$HOME/.config/libreoffice"

success "LibreOffice installed successfully!"
echo ""
echo "LibreOffice - Free alternative to Microsoft Office"
echo "  - Office suite: https://www.libreoffice.org/"
echo "  - Components: Writer, Calc, Impress, Draw, Base, Math"
echo "  - Run: libreoffice"
echo "  - Config: ~/.config/libreoffice/"
