#!/bin/bash
set -euo pipefail

# Omabunty Live USB Creator
# Writes ISO to USB drive

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }

usage() {
    echo "Omabunty Live USB Creator"
    echo ""
    echo "Usage: $0 [iso-file]"
    echo ""
    echo "Examples:"
    echo "  $0                    # Use default ISO"
    echo "  $0 omabunty-24.04.iso # Specify ISO file"
    echo ""
    echo "To create ISO first: cd iso && ./build-iso.sh"
}

find_iso() {
    local iso_path=""
    
    # Check default locations
    for path in \
        "$HOME/omabunty/iso/build/omabunty-24.04.iso" \
        "./omabunty-24.04.iso" \
        "/tmp/omabunty-24.04.iso"; do
        if [[ -f "$path" ]]; then
            iso_path="$path"
            break
        fi
    done
    
    echo "$iso_path"
}

list_usb_devices() {
    echo "Available USB devices:"
    echo ""
    
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep "disk" | while read -r line; do
        if [[ ! "$line" =~ nvme ]]; then
            echo "  /dev/$line"
        fi
    done
    
    echo ""
    echo "USB drives (removeable):"
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,RM | grep "1" | grep "disk" | while read -r line; do
        local device=$(echo "$line" | awk '{print "/dev/" $1}')
        local size=$(echo "$line" | awk '{print $2}')
        echo "  $device ($size)"
    done
}

select_device() {
    local devices=()
    
    while IFS= read -r line; do
        if [[ "$line" =~ /dev/sd ]]; then
            devices+=("$line")
        fi
    done < <(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,RM | grep "1" | grep "disk")
    
    if [[ ${#devices[@]} -eq 0 ]]; then
        error "No USB devices found"
        exit 1
    fi
    
    if [[ ${#devices[@]} -eq 1 ]]; then
        echo "${devices[0]}" | awk '{print $1}'
        return
    fi
    
    echo "Select USB device:"
    select dev in "${devices[@]}"; do
        if [[ -n "$dev" ]]; then
            echo "$dev" | awk '{print $1}'
            break
        fi
    done
}

verify_iso() {
    local iso="$1"
    
    if [[ ! -f "$iso" ]]; then
        error "ISO not found: $iso"
        exit 1
    fi
    
    if file "$iso" | grep -q "ISO 9660"; then
        success "Valid ISO file"
    else
        error "Not a valid ISO file"
        exit 1
    fi
}

write_usb() {
    local iso="$1"
    local device="$2"
    
    warn "ALL DATA ON $device WILL BE ERASED!"
    echo ""
    read -p "Continue? (y/n) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Aborted"
        exit 0
    fi
    
    info "Unmounting any mounted partitions..."
    sudo umount "${device}"* 2>/dev/null || true
    
    info "Writing ISO to USB..."
    sudo dd if="$iso" of="$device" bs=4M status=progress oflag=sync
    
    info "Syncing..."
    sync
    
    success "Live USB created!"
    echo ""
    echo "Boot from: $device"
    echo ""
    echo "Tips:"
    echo "  - Enter BIOS/UEFI and select USB as boot device"
    echo "  - On most PCs, press F2, F12, or Del during boot"
    echo "  - Select 'Omabunty Live' from the boot menu"
}

main() {
    local iso="${1:-}"
    
    if [[ -z "$iso" ]]; then
        iso=$(find_iso)
    fi
    
    if [[ -z "$iso" ]]; then
        usage
        echo ""
        error "ISO not found. Build ISO first: cd iso && ./build-iso.sh"
        exit 1
    fi
    
    verify_iso "$iso"
    
    echo ""
    echo "ISO: $iso"
    ls -lh "$iso"
    echo ""
    
    list_usb_devices
    
    local device=$(select_device)
    
    if [[ -z "$device" ]]; then
        error "No device selected"
        exit 1
    fi
    
    write_usb "$iso" "$device"
}

main "$@"