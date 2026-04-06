#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

apply_all_configs() {
    info "Applying all Omabunty configurations..."
    
    for script in "$SCRIPT_DIR"/configs/apply-*.sh; do
        if [[ -f "$script" ]]; then
            info "Applying: $(basename "$script")"
            bash "$script" || warn "Failed: $(basename "$script")"
        fi
    done
    
    success "All configurations applied"
}

main() {
    apply_all_configs
}

main "$@"