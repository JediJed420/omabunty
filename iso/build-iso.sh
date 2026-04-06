#!/bin/bash
set -euo pipefail

# Omabunty ISO Builder
# Creates a bootable ISO with Ubuntu 24.04 base + Omabunty

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ISO_DIR="$SCRIPT_DIR"
BUILD_DIR="$ISO_DIR/build"
WORK_DIR="$BUILD_DIR/omabunty-live"
IMAGE_DIR="$WORK_DIR/image"
UBUNTU_ISO="/tmp/ubuntu-24.04-live.iso"
UBUNTU_MOUNT="/tmp/ubuntu-mount"

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
    local missing=()
    for cmd in debootstrap mksquashfs xorriso wget; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing dependencies: ${missing[*]}"
        info "Install with: sudo apt install debootstrap squashfs-tools xorriso wget"
        exit 1
    fi
    success "Dependencies OK"
}

download_ubuntu() {
    if [[ -f "$UBUNTU_ISO" ]]; then
        info "Ubuntu ISO already exists"
        return
    fi
    
    info "Downloading Ubuntu 24.04.4 LTS Live ISO..."
    wget -O "$UBUNTU_ISO" \
        "https://releases.ubuntu.com/24.04/ubuntu-24.04.4-desktop-amd64.iso" \
        --progress=bar:force
    success "Ubuntu ISO downloaded"
}

extract_ubuntu() {
    info "Extracting Ubuntu ISO..."
    
    mkdir -p "$UBUNTU_MOUNT"
    sudo mount -o loop "$UBUNTU_ISO" "$UBUNTU_MOUNT"
    
    mkdir -p "$IMAGE_DIR"
    cp -r "$UBUNTU_MOUNT"/* "$IMAGE_DIR/"
    cp -r "$UBUNTU_MOUNT"/.* "$IMAGE_DIR/" 2>/dev/null || true
    
    sudo umount "$UBUNTU_MOUNT"
    rmdir "$UBUNTU_MOUNT"
    
    success "Ubuntu ISO extracted"
}

prepare_dirs() {
    info "Preparing build directories..."
    rm -rf "$BUILD_DIR"
    mkdir -p "$IMAGE_DIR/casper"
    mkdir -p "$IMAGE_DIR/.disk"
    mkdir -p "$WORK_DIR/rootfs"
    success "Directories prepared"
}

create_rootfs() {
    info "Creating root filesystem with debootstrap..."
    
    sudo debootstrap --variant=minbase --include=ubuntu-standard,noble \
        noble "$WORK_DIR/rootfs" http://archive.ubuntu.com/ubuntu/
    
    success "Base rootfs created"
}

configure_rootfs() {
    info "Configuring rootfs..."
    
    # Set locale
    echo "en_US.UTF-8 UTF-8" | sudo tee -a "$WORK_DIR/rootfs/etc/locale.gen"
    sudo chroot "$WORK_DIR/rootfs" locale-gen
    
    # Set hostname
    echo "omabunty" | sudo tee "$WORK_DIR/rootfs/etc/hostname"
    
    # Create user
    sudo chroot "$WORK_DIR/rootfs" useradd -m -s /bin/bash omabunty
    echo "omabunty:omabunty" | sudo chroot "$WORK_DIR/rootfs" chpasswd
    
    # Enable autologin
    sudo mkdir -p "$WORK_DIR/rootfs/etc/systemd/system/getty@tty1.service.d"
    echo -e "[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin omabunty --noclear %I" | \
        sudo tee "$WORK_DIR/rootfs/etc/systemd/system/getty@tty1.service.d/override.conf"
    
    success "Rootfs configured"
}

install_packages() {
    info "Installing packages in rootfs..."
    
    # Mount proc, sys, dev
    sudo mount -t proc /proc "$WORK_DIR/rootfs/proc"
    sudo mount -t sysfs /sys "$WORK_DIR/rootfs/sys"
    sudo mount -t devpts /dev/pts "$WORK_DIR/rootfs/dev/pts"
    
    # Set apt sources
    cat > /tmp/sources.list << 'EOF'
deb http://archive.ubuntu.com/ubuntu/ noble main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ noble-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ noble-security main restricted universe multiverse
EOF
    sudo cp /tmp/sources.list "$WORK_DIR/rootfs/etc/apt/sources.list"
    
    # Install packages
    sudo chroot "$WORK_DIR/rootfs" apt-get update
    sudo chroot "$WORK_DIR/rootfs" apt-get install -y \
        sudo vim wget curl git \
        hyprland waybar rofi alacritty kitty \
        neovim zsh starship \
        network-manager gnome-system-tools \
        xdg-utils libnotify-bin \
        fzf \
        locales \
        libreoffice-gnome libreoffice-gtk3 \
        || warn "Some packages may have failed"
    
    # Unmount
    sudo umount "$WORK_DIR/rootfs/proc"
    sudo umount "$WORK_DIR/rootfs/sys"
    sudo umount "$WORK_DIR/rootfs/dev/pts"
    
    success "Packages installed"
}

copy_configs() {
    info "Copying Omabunty configs..."
    
    # Copy Hyprland config
    sudo mkdir -p "$WORK_DIR/rootfs/home/omabunty/.config/hypr"
    sudo cp -r "$PROJECT_DIR/configs/hypr/"* "$WORK_DIR/rootfs/home/omabunty/.config/hypr/"
    
    # Copy waybar config
    sudo mkdir -p "$WORK_DIR/rootfs/home/omabunty/.config/waybar"
    sudo cp -r "$PROJECT_DIR/configs/waybar/"* "$WORK_DIR/rootfs/home/omabunty/.config/waybar/"
    
    # Copy alacritty config
    sudo mkdir -p "$WORK_DIR/rootfs/home/omabunty/.config/alacritty"
    sudo cp -r "$PROJECT_DIR/configs/alacritty/"* "$WORK_DIR/rootfs/home/omabunty/.config/alacritty/"
    
    # Copy kitty config
    sudo mkdir -p "$WORK_DIR/rootfs/home/omabunty/.config/kitty"
    sudo cp -r "$PROJECT_DIR/configs/kitty/"* "$WORK_DIR/rootfs/home/omabunty/.config/kitty/"
    
    # Copy sddm config
    sudo mkdir -p "$WORK_DIR/rootfs/home/omabunty/.config/sddm"
    sudo cp -r "$PROJECT_DIR/configs/sddm/"* "$WORK_DIR/rootfs/home/omabunty/.config/sddm/"
    
    # Copy starship
    sudo mkdir -p "$WORK_DIR/rootfs/home/omabunty/.config"
    sudo cp "$PROJECT_DIR/configs/starship.toml" "$WORK_DIR/rootfs/home/omabunty/.config/"
    
    # Copy scripts
    sudo mkdir -p "$WORK_DIR/rootfs/home/omabunty/omabunty"
    sudo cp -r "$PROJECT_DIR"/* "$WORK_DIR/rootfs/home/omabunty/omabunty/"
    
    # Set ownership
    sudo chown -R omabunty:omabunty "$WORK_DIR/rootfs/home/omabunty"
    
    success "Configs copied"
}

create_autostart() {
    info "Creating autostart configuration..."
    
    # Create .desktop autostart
    sudo mkdir -p "$WORK_DIR/rootfs/home/omabunty/.config/autostart"
    cat > "$WORK_DIR/rootfs/home/omabunty/.config/autostart/hyprland.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Hyprland
Exec=/usr/bin/hyprland
EOF
    
    success "Autostart configured"
}

build_squashfs() {
    info "Building squashfs image..."
    
    # Remove filesystem.squashfs if exists
    rm -f "$IMAGE_DIR/casper/filesystem.squashfs"
    
    sudo mksquashfs "$WORK_DIR/rootfs" "$IMAGE_DIR/casper/filesystem.squashfs" \
        -comp zstd -no-progress -wildcards \
        -e "proc" -e "sys" -e "dev" -e "run"
    
    success "Squashfs image created"
}

create_manifest() {
    info "Creating manifest..."
    
    dpkg-query -W -f='${Package} ${Version}\n' | sudo tee "$IMAGE_DIR/casper/filesystem.manifest" > /dev/null
    
    success "Manifest created"
}

create_md5sums() {
    info "Calculating checksums..."
    
    (cd "$IMAGE_DIR" && find . -type f -exec md5sum {} \;) | \
        grep -v "filesystem.squashfs" > "$IMAGE_DIR/casper/md5sum.txt"
    
    # Add squashfs checksum
    md5sum "$IMAGE_DIR/casper/filesystem.squashfs" >> "$IMAGE_DIR/casper/md5sum.txt"
    
    success "Checksums calculated"
}

update_disk_info() {
    info "Updating disk info..."
    
    # Calculate sizes
    ROOTFS_SIZE=$(du -sb "$WORK_DIR/rootfs" | cut -f1)
    CASPER_SIZE=$(du -sb "$IMAGE_DIR/casper/filesystem.squashfs" | cut -f1)
    
    cat > "$IMAGE_DIR/.disk/info" << EOF
Omabunty 24.04 LTS (Omarchy-style)
x86_64
Live Session
Total size: $(( (ROOTFS_SIZE + CASPER_SIZE) / 1024 / 1024 )) MB
EOF
    
    success "Disk info updated"
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
        -append_partition 2 "$IMAGE_DIR/casper/filesystem.squashfs" \
        -appended_part_as_gpt \
        "$IMAGE_DIR"
    
    success "ISO created: $BUILD_DIR/omabunty-24.04.iso"
}

cleanup() {
    info "Cleaning up..."
    rm -f "$UBUNTU_ISO"
    rm -rf "$WORK_DIR"
    success "Cleanup done"
}

main() {
    info "Starting Omabunty ISO build..."
    
    check_deps
    download_ubuntu
    extract_ubuntu
    prepare_dirs
    create_rootfs
    configure_rootfs
    install_packages
    copy_configs
    create_autostart
    build_squashfs
    create_manifest
    create_md5sums
    update_disk_info
    build_iso
    
    echo ""
    success "ISO build complete!"
    ls -lh "$BUILD_DIR/omabunty-24.04.iso"
    echo ""
    echo "To create a Live USB:"
    echo "  sudo dd if=$BUILD_DIR/omabunty-24.04.iso of=/dev/sdX bs=4M status=progress"
}

main "$@"