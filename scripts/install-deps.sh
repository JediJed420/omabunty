#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

install_core_deps() {
    info "Installing core dependencies..."
    
    sudo apt-get update
    sudo apt-get install -y \
        build-essential \
        cmake \
        pkg-config \
        libssl-dev \
        git \
        curl \
        wget \
        unzip
        
    success "Core dependencies installed"
}

install_display() {
    info "Installing display server and window manager..."
    
    sudo apt-get install -y \
        wayland \
        hyprland \
        libinput-dev \
        libpango2.0-dev \
        libpixman-1-dev \
        libcairo2-dev \
        libglib2.0-dev \
        libuv1-dev \
        libsystemd-dev \
        libdrm-dev \
        libgbm-dev \
        libseat-dev \
        libxkbcommon-dev \
        libpulse-dev \
        libxcb-icccm-dev \
        libxcb-keysyms1-dev \
        libxcb-render0-dev \
        libxcb-shape0-dev \
        libxcb-xfixes0-dev \
        libegl-dev \
        libgles-dev \
        libmirclient-dev \
        libwayland-dev
    
    success "Display components installed"
}

install_terminals() {
    info "Installing terminal emulators..."
    
    sudo apt-get install -y \
        alacritty \
        kitty \
        zsh \
        starship \
        eza \
        bat
        
    success "Terminal emulators installed"
}

install_ui_tools() {
    info "Installing UI tools..."
    
    sudo apt-get install -y \
        waybar \
        wofi \
        rofi \
        picom \
        wlogout \
        sddm \
        gimp \
        audacity \
        btop \
        neovim
        
    success "UI tools installed"
}

install_zsh() {
    info "Installing Zsh and Oh My Zsh..."
    
    sudo apt-get install -y zsh
    
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    success "Zsh configured"
}

install_iso_deps() {
    info "Installing ISO build dependencies..."
    
    sudo apt-get install -y \
        squashfs-tools \
        genisoimage \
        xorriso \
        isolinux \
        syslinux-common \
        syslinux-utils \
        parted \
        gdisk \
        debootstrap \
        wget
        
    success "ISO build dependencies installed"
}

main() {
    info "Installing all dependencies..."
    
    install_core_deps
    install_display
    install_terminals
    install_ui_tools
    install_zsh
    install_iso_deps
    
    success "All dependencies installed!"
}

main "$@"