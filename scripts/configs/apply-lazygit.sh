#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

install_lazygit() {
    info "Installing lazygit (free terminal UI for git)..."
    
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -oP '"tag_name": "\K[^"]+' | tr -d 'v')
    
    if [[ -n "$LAZYGIT_VERSION" ]]; then
        cd /tmp
        curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_amd64.tar.gz"
        tar xzf lazygit.tar.gz
        sudo mv lazygit /usr/local/bin/lazygit
        rm lazygit.tar.gz
        cd - >/dev/null
    else
        sudo apt install -y lazygit
    fi
}

setup_config() {
    mkdir -p "$HOME/.config/lazygit"
    mkdir -p "$BACKUP_DIR/lazygit"
    
    if [ -f "$HOME/.config/lazygit/config.yml" ]; then
        cp "$HOME/.config/lazygit/config.yml" "$BACKUP_DIR/lazygit/config.yml.bak"
    fi
    
    cp "$SCRIPT_DIR/../../config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml" 2>/dev/null || true
}

main() {
    install_lazygit
    setup_config
    
    success "lazygit installed successfully!"
    echo ""
    echo "lazygit - Terminal UI for git"
    echo "  - Run: lazygit"
    echo "  - Config: ~/.config/lazygit/"
}

main "$@"