#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.omabunty-backups"

source "${SCRIPT_DIR}/../colors.sh"

MANAGED_CONFIGS=(
    "hypr"
    "waybar"
    "alacritty"
    "kitty"
    "picom"
    "rofi"
    "wofi"
    "wlogout"
    "nvim"
    "aether"
    "zsh"
    "starship"
    "waybar"
)

create_backup_timestamp() {
    date +"%Y%m%d_%H%M%S"
}

list_backups() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        info "No backups found. Backup directory does not exist."
        return
    fi

    local backups=("$BACKUP_DIR"/*/)
    if [[ ${#backups[@]} -eq 0 ]] || [[ ! -e "${backups[0]}" ]]; then
        info "No backups found."
        return
    fi

    info "Available backups:"
    printf "  %-25s %s\n" "Backup Name" "Date"
    echo "  ------------------------------------------------"

    for backup in "$BACKUP_DIR"/*/; do
        local name
        name=$(basename "$backup")
        local date_str
        date_str=$(echo "$name" | sed 's/_/ /g' | sed 's/\([0-9]\{8\}\) /\1-/')
        printf "  %-25s %s\n" "$name" "$date_str"
    done
}

backup_config() {
    local config_name="$1"
    local timestamp
    timestamp=$(create_backup_timestamp)
    local backup_path="${BACKUP_DIR}/${timestamp}_${config_name}"

    case "$config_name" in
        hypr)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.config/hypr" "$backup_path/" 2>/dev/null || true
            ;;
        waybar)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.config/waybar" "$backup_path/" 2>/dev/null || true
            ;;
        alacritty)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.config/alacritty" "$backup_path/" 2>/dev/null || true
            ;;
        kitty)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.config/kitty" "$backup_path/" 2>/dev/null || true
            ;;
        picom)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.config/picom" "$backup_path/" 2>/dev/null || true
            ;;
        rofi)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.config/rofi" "$backup_path/" 2>/dev/null || true
            ;;
        wofi)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.config/wofi" "$backup_path/" 2>/dev/null || true
            ;;
        wlogout)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.config/wlogout" "$backup_path/" 2>/dev/null || true
            ;;
        nvim)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.config/nvim" "$backup_path/" 2>/dev/null || true
            ;;
        aether)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.config/aether" "$backup_path/" 2>/dev/null || true
            ;;
        zsh)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.zshrc" "${HOME}/.oh-my-zsh" "$backup_path/" 2>/dev/null || true
            ;;
        starship)
            mkdir -p "$backup_path"
            cp -r "${HOME}/.config/starship.toml" "$backup_path/" 2>/dev/null || true
            ;;
        *)
            error "Unknown config: $config_name"
            return 1
            ;;
    esac

    if [[ -d "$backup_path" ]] && [[ "$(ls -A "$backup_path" 2>/dev/null)" ]]; then
        success "Backed up $config_name to $backup_path"
    else
        warn "No existing config found for $config_name (skipping)"
        rm -rf "$backup_path"
    fi
}

backup_all() {
    info "Backing up all managed configs..."

    mkdir -p "$BACKUP_DIR"

    for config in "${MANAGED_CONFIGS[@]}"; do
        backup_config "$config"
    done

    success "Backup complete!"
    info "Backups stored in: $BACKUP_DIR"
}

show_usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
    -a, --all          Backup all managed configs
    -s, --specific     Backup specific config (hypr, waybar, alacritty, etc.)
    -l, --list         List available backups
    -h, --help         Show this help message

Examples:
    $(basename "$0") --all
    $(basename "$0") --specific hypr
    $(basename "$0") --list
EOF
}

main() {
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 0
    fi

    case "$1" in
        -a|--all)
            backup_all
            ;;
        -s|--specific)
            if [[ -z "${2:-}" ]]; then
                error "Please specify a config name"
                show_usage
                exit 1
            fi
            mkdir -p "$BACKUP_DIR"
            backup_config "$2"
            success "Backup complete!"
            ;;
        -l|--list)
            list_backups
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
}

main "$@"
