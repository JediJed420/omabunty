#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/scripts/colors.sh"

main() {
    local mode="${1:-fresh}"
    
    case "$mode" in
        fresh)
            info "Running fresh Ubuntu installation..."
            "$SCRIPT_DIR/scripts/fresh-install.sh"
            ;;
        upgrade)
            info "Running in-place upgrade..."
            "$SCRIPT_DIR/scripts/upgrade.sh"
            ;;
        deps)
            info "Installing dependencies..."
            "$SCRIPT_DIR/scripts/install-deps.sh"
            ;;
        all)
            info "Installing all Omabunty components..."
            "$SCRIPT_DIR/scripts/install-all.sh"
            ;;
        iso)
            info "Building ISO..."
            "$SCRIPT_DIR/iso/build-iso.sh"
            ;;
        usb)
            info "Creating Live USB..."
            "$SCRIPT_DIR/iso/create-live-usb.sh" "${2:-}"
            ;;
        *)
            error "Unknown mode: $mode"
            echo "Usage: $0 {fresh|upgrade|deps|all|iso|usb}"
            echo ""
            echo "Modes:"
            echo "  fresh   - Fresh Ubuntu installation"
            echo "  upgrade - In-place upgrade"
            echo "  deps    - Install dependencies only"
            echo "  all     - Install all Omabunty components"
            echo "  iso     - Build ISO image"
            echo "  usb     - Create Live USB (optional: specify ISO path)"
            exit 1
            ;;
    esac
}

main "$@"