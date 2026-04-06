#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../colors.sh"

apply_environment_config() {
    info "Applying environment variables..."
    
    mkdir -p "$HOME/.config/environment.d"
    cp "$SCRIPT_DIR/../../config/environment.d/"*.conf "$HOME/.config/environment.d/"
    
    success "Environment config applied"
}

apply_environment_config
