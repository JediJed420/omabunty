#!/bin/bash
# Launch Alacritty with tmux

alacritty -e tmux 2>/dev/null || alacritty -e "tmux new-session -A -s main" 2>/dev/null || {
    echo "tmux not installed"
    echo "Installing tmux..."
    sudo apt install -y tmux
    alacritty -e tmux
}