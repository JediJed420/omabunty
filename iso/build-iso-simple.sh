#!/bin/bash
set -euo pipefail

# Omabunty ISO Builder - Simplified version
# Takes existing Ubuntu ISO and adds Omabunty overlay

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
UBUNTU_ISO="${1:-/tmp/ubuntu-24.04-live.iso}"
BUILD_DIR="$SCRIPT_DIR/build"
IMAGE_DIR="$BUILD_DIR/image"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }

check_deps() {
    info "Checking dependencies..."
    for cmd in xorriso wget; do
        if ! command -v "$cmd" &>/dev/null; then
            error "Missing: $cmd"
            exit 1
        fi
    done
    success "Dependencies OK"
}

download_ubuntu() {
    if [[ -f "$UBUNTU_ISO" ]]; then
        info "Ubuntu ISO already exists: $UBUNTU_ISO"
        return
    fi
    
    info "Downloading Ubuntu 24.04.4 LTS Live ISO..."
    mkdir -p "$(dirname "$UBUNTU_ISO")"
    wget -O "$UBUNTU_ISO" \
        "https://releases.ubuntu.com/24.04/ubuntu-24.04.4-desktop-amd64.iso" \
        --progress=bar:force
    success "Ubuntu ISO downloaded"
}

extract_iso() {
    info "Extracting Ubuntu ISO..."
    
    rm -rf "$BUILD_DIR"
    mkdir -p "$IMAGE_DIR"
    
    if mountpoint -q /mnt/ubuntu-iso 2>/dev/null; then
        sudo umount /mnt/ubuntu-iso
    fi
    
    sudo mkdir -p /mnt/ubuntu-iso
    sudo mount -o loop "$UBUNTU_ISO" /mnt/ubuntu-iso
    
    cp -r /mnt/ubuntu-iso/* "$IMAGE_DIR/"
    cp -r /mnt/ubuntu-iso/.* "$IMAGE_DIR/" 2>/dev/null || true
    
    sudo umount /mnt/ubuntu-iso
    rmdir /mnt/ubuntu-iso
    
    success "ISO extracted"
}

add_omabunty_overlay() {
    info "Adding Omabunty overlay..."
    
    mkdir -p "$IMAGE_DIR/casper"
    mkdir -p "$IMAGE_DIR/.disk"
    
    # Create Omabunty branding
    cat > "$IMAGE_DIR/.disk/info" << 'EOF'
Omabunty 24.04 LTS
x86_64
Live Session
EOF

    # Add Omabunty docs
    mkdir -p "$IMAGE_DIR/omabunty"
    cat > "$IMAGE_DIR/omabunty/README" << 'EOF'
# Omabunty - Ubuntu-based Omarchy Clone

This is a live session with Omabunty pre-configured.

To install:
  1. Run 'sudo ./install.sh fresh' for fresh install
  2. Run 'sudo ./install.sh upgrade' for in-place upgrade

For more info: https://github.com/JediJed420/omabunty
EOF

    # Copy installer scripts
    mkdir -p "$IMAGE_DIR/omabunty/scripts"
    cp -r "$PROJECT_DIR/install.sh" "$IMAGE_DIR/omabunty/"
    cp -r "$PROJECT_DIR/scripts" "$IMAGE_DIR/omabunty/"
    cp -r "$PROJECT_DIR/configs" "$IMAGE_DIR/omabunty/"
    
    # Copy config if exists
    if [ -d "$PROJECT_DIR/config" ]; then
        cp -r "$PROJECT_DIR/config" "$IMAGE_DIR/omabunty/"
    fi
    
    # Copy themes if exists
    if [ -d "$PROJECT_DIR/themes" ]; then
        cp -r "$PROJECT_DIR/themes" "$IMAGE_DIR/omabunty/"
    fi
    
    # Make scripts executable
    chmod +x "$IMAGE_DIR/omabunty/install.sh"
    find "$IMAGE_DIR/omabunty/scripts" -name "*.sh" -exec chmod +x {} \;
    
    success "Omabunty overlay added"
}

update_manifest() {
    info "Updating manifest..."
    
    # Calculate filesystem size
    TOTAL_SIZE=$(du -sb "$IMAGE_DIR" | cut -f1)
    echo "Omabunty 24.04 LTS - Total size: $((TOTAL_SIZE / 1024 / 1024)) MB" > "$IMAGE_DIR/.disk/info"
    
    success "Manifest updated"
}

build_iso() {
    info "Building ISO image..."
    
    rm -f "$BUILD_DIR/omabunty-24.04.iso"
    
    xorriso \
        -as mkisofs \
        -r \
        -V "Omabunty 24.04 LTS" \
        -o "$BUILD_DIR/omabunty-24.04.iso" \
        -cache-inodes \
        -joliet \
        -rock \
        -partition_offset 16 \
        "$IMAGE_DIR"
    
    success "ISO created: $BUILD_DIR/omabunty-24.04.iso"
    ls -lh "$BUILD_DIR/omabunty-24.04.iso"
}

main() {
    info "Starting Omabunty ISO build (simplified)..."
    
    check_deps
    download_ubuntu
    extract_iso
    add_omabunty_overlay
    update_manifest
    build_iso
    
    echo ""
    success "ISO build complete!"
    echo ""
    echo "To create a Live USB:"
    echo "  sudo dd if=$BUILD_DIR/omabunty-24.04.iso of=/dev/sdX bs=4M status=progress"
}

main "$@"
