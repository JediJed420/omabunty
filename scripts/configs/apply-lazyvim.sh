#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.omabunty-backup"

source "$SCRIPT_DIR/../../colors.sh"

install_neovim() {
    info "Installing Neovim (LazyVim)..."
    
    if ! command -v nvim &>/dev/null; then
        sudo apt update
        sudo apt install -y neovim
    fi
    
    if ! command -v nvim &>/dev/null; then
        info "Installing Neovim from source..."
        NVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep -oP '"tag_name": "\K[^"]+' | tr -d 'v')
        cd /tmp
        curl -sLo nvim-linux64.tar.gz "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux64.tar.gz"
        sudo tar xzf nvim-linux64.tar.gz -C /opt
        sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
        rm nvim-linux64.tar.gz
        cd - >/dev/null
    fi
}

setup_lazyvim() {
    info "Setting up LazyVim..."
    
    mkdir -p "$HOME/.config/nvim"
    mkdir -p "$HOME/.local/share/nvim/lazy"
    mkdir -p "$BACKUP_DIR/nvim"
    
    if [ -f "$HOME/.config/nvim/init.lua" ]; then
        cp "$HOME/.config/nvim/init.lua" "$BACKUP_DIR/nvim/init.lua.bak"
    fi
    
    if [ -d "$HOME/.config/nvim/lua" ]; then
        cp -r "$HOME/.config/nvim/lua" "$BACKUP_DIR/nvim/lua.bak" 2>/dev/null || true
    fi
    
    cat > "$HOME/.config/nvim/init.lua" << 'EOF'
-- LazyVim configuration for Omabunty
-- https://lazyvim.github.io

-- Set leader keys before loading
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set LazyVim home
vim.env.LAZYVIM_CONFIG_DIR = vim.fn.stdpath("config")
vim.env.LAZYVIM_STATE_DIR = vim.fn.stdpath("state")

-- Bootstrap LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/LazyVim/LazyVim.git",
    "--depth=1",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load lazyvim
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    import = "plugins",
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "netrwPlugin",
      },
    },
  },
})

-- Set colorscheme
vim.cmd.colorscheme("tokyonight")
EOF

    mkdir -p "$HOME/.config/nvim/lua/plugins"
    
    cat > "$HOME/.config/nvim/lua/plugins/omabunty.lua" << 'EOF'
-- Omabunty LazyVim config
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
EOF
    
    success "LazyVim configured successfully!"
}

main() {
    install_neovim
    setup_lazyvim
    
    success "LazyVim installed and configured!"
    echo ""
    echo "LazyVim - Neovim preset"
    echo "  - Docs: https://lazyvim.github.io/"
    echo "  - Run: nvim"
    echo "  - Config: ~/.config/nvim/"
    echo ""
    echo "Run 'nvim' to complete LazyVim setup on first launch."
}

main "$@"