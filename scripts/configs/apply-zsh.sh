#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

info "Setting up Zsh with Oh My Zsh..."

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --skip-chsh
fi

# Install Zsh plugins
ZSH_PLUGINS="$HOME/.oh-my-zsh/custom/plugins"

mkdir -p "$ZSH_PLUGINS"

# zsh-autosuggestions
if [ ! -d "$ZSH_PLUGINS/zsh-autosuggestions" ]; then
    info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ]; then
    info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS/zsh-syntax-highlighting"
fi

# zsh-completions (should be in omz but ensure it's enabled)
if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-completions" ]; then
    info "Installing zsh-completions..."
    git clone https://github.com/zsh-users/zsh-completions "$ZSH_PLUGINS/zsh-completions"
fi

# Backup existing .zshrc
mkdir -p "$BACKUP_DIR/zsh"
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$BACKUP_DIR/zsh/.zshrc.bak"
fi

# Create new .zshrc with Omabunty settings
cat > "$HOME/.zshrc" << 'EOF'
# Omabunty Zsh Configuration

# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme - using starship prompt
ZSH_THEME=""

# Enable plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    docker
    kubectl
    terraform
)

# Load Starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"

# Custom aliases
alias ll='eza -la --icons --git'
alias la='eza -la --icons'
alias ls='eza --icons'
alias cat='bat'
alias find='fd'
alias grep='rg'

# History settings
export HISTSIZE=10000
export SAVEHIST=10000
export HISTCONTROL=ignoredups:erasedups
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# Keybindings
bindkey '^R' history-incremental-search-backward

# Enable color support
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Load completion for starship (if exists)
autoload -U compinit
compinit
EOF

# Install starship if not present
if ! command -v starship &> /dev/null; then
    info "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Copy Starship config
info "Configuring Starship prompt..."
mkdir -p "$HOME/.config"
cp "$SCRIPT_DIR/../../config/starship.toml" "$HOME/.config/starship.toml"

# Install eza (modern ls) and bat if not present
if ! command -v eza &> /dev/null; then
    info "Installing eza (modern ls)..."
    sudo apt install -y eza 2>/dev/null || cargo install eza
fi

if ! command -v bat &> /dev/null; then
    info "Installing bat (modern cat)..."
    sudo apt install -y bat 2>/dev/null || cargo install bat
fi

# Install fd and ripgrep if not present
if ! command -v fd &> /dev/null; then
    info "Installing fd (modern find)..."
    sudo apt install -y fd-find 2>/dev/null || cargo install fd-find
fi

if ! command -v rg &> /dev/null; then
    info "Installing ripgrep..."
    sudo apt install -y ripgrep
fi

success "Zsh with Oh My Zsh configured successfully!"

info "To use Zsh as default shell, run: chsh -s /bin/zsh"