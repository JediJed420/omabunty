#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${HOME}/.omabunty-backups"

source "${SCRIPT_DIR}/../colors.sh"

list_backups() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        info "No backups found."
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

get_backup_type() {
    local backup_name="$1"
    
    if [[ "$backup_name" =~ (^|[_-])hypr[_-]? ]]; then echo "hypr"; return; fi
    if [[ "$backup_name" =~ (^|[_-])waybar[_-]? ]]; then echo "waybar"; return; fi
    if [[ "$backup_name" =~ (^|[_-])alacritty[_-]? ]]; then echo "alacritty"; return; fi
    if [[ "$backup_name" =~ (^|[_-])kitty[_-]? ]]; then echo "kitty"; return; fi
    if [[ "$backup_name" =~ (^|[_-])picom[_-]? ]]; then echo "picom"; return; fi
    if [[ "$backup_name" =~ (^|[_-])rofi[_-]? ]]; then echo "rofi"; return; fi
    if [[ "$backup_name" =~ (^|[_-])wofi[_-]? ]]; then echo "wofi"; return; fi
    if [[ "$backup_name" =~ (^|[_-])wlogout[_-]? ]]; then echo "wlogout"; return; fi
    if [[ "$backup_name" =~ (^|[_-])nvim[_-]? ]]; then echo "nvim"; return; fi
    if [[ "$backup_name" =~ (^|[_-])aether[_-]? ]]; then echo "aether"; return; fi
    if [[ "$backup_name" =~ (^|[_-])zsh[_-]? ]]; then echo "zsh"; return; fi
    if [[ "$backup_name" =~ (^|[_-])starship[_-]? ]]; then echo "starship"; return; fi
    
    echo "unknown"
}

restore_config() {
    local backup_name="$1"
    local backup_path="${BACKUP_DIR}/${backup_name}"
    local dry_run="${2:-false}"

    if [[ ! -d "$backup_path" ]]; then
        error "Backup not found: $backup_name"
        return 1
    fi

    local config_type
    config_type=$(get_backup_type "$backup_name")

    if [[ "$config_type" == "unknown" ]]; then
        error "Could not determine config type for: $backup_name"
        return 1
    fi

    if [[ "$dry_run" == "true" ]]; then
        info "[DRY RUN] Would restore: $config_type from $backup_name"
        return 0
    fi

    case "$config_type" in
        hypr)
            mkdir -p "${HOME}/.config/hypr"
            rm -rf "${HOME}/.config/hypr"/*
            cp -r "$backup_path/hypr"/* "${HOME}/.config/hypr/" 2>/dev/null || true
            ;;
        waybar)
            mkdir -p "${HOME}/.config/waybar"
            rm -rf "${HOME}/.config/waybar"/*
            cp -r "$backup_path/waybar"/* "${HOME}/.config/waybar/" 2>/dev/null || true
            ;;
        alacritty)
            mkdir -p "${HOME}/.config/alacritty"
            rm -rf "${HOME}/.config/alacritty"/*
            cp -r "$backup_path/alacritty"/* "${HOME}/.config/alacritty/" 2>/dev/null || true
            ;;
        kitty)
            mkdir -p "${HOME}/.config/kitty"
            rm -rf "${HOME}/.config/kitty"/*
            cp -r "$backup_path/kitty"/* "${HOME}/.config/kitty/" 2>/dev/null || true
            ;;
        picom)
            mkdir -p "${HOME}/.config/picom"
            rm -rf "${HOME}/.config/picom"/*
            cp -r "$backup_path/picom"/* "${HOME}/.config/picom/" 2>/dev/null || true
            ;;
        rofi)
            mkdir -p "${HOME}/.config/rofi"
            rm -rf "${HOME}/.config/rofi"/*
            cp -r "$backup_path/rofi"/* "${HOME}/.config/rofi/" 2>/dev/null || true
            ;;
        wofi)
            mkdir -p "${HOME}/.config/wofi"
            rm -rf "${HOME}/.config/wofi"/*
            cp -r "$backup_path/wofi"/* "${HOME}/.config/wofi/" 2>/dev/null || true
            ;;
        wlogout)
            mkdir -p "${HOME}/.config/wlogout"
            rm -rf "${HOME}/.config/wlogout"/*
            cp -r "$backup_path/wlogout"/* "${HOME}/.config/wlogout/" 2>/dev/null || true
            ;;
        nvim)
            mkdir -p "${HOME}/.config/nvim"
            rm -rf "${HOME}/.config/nvim"/*
            cp -r "$backup_path/nvim"/* "${HOME}/.config/nvim/" 2>/dev/null || true
            ;;
        aether)
            mkdir -p "${HOME}/.config/aether"
            rm -rf "${HOME}/.config/aether"/*
            cp -r "$backup_path/aether"/* "${HOME}/.config/aether/" 2>/dev/null || true
            ;;
        zsh)
            cp -r "$backup_path/.zshrc" "${HOME}/" 2>/dev/null || true
            cp -r "$backup_path/.oh-my-zsh" "${HOME}/" 2>/dev/null || true
            ;;
        starship)
            mkdir -p "${HOME}/.config"
            cp -r "$backup_path/starship.toml" "${HOME}/.config/" 2>/dev/null || true
            ;;
    esac

    success "Restored $config_type from $backup_name"
}

restore_latest() {
    local config_type="$1"
    local dry_run="${2:-false}"

    local latest_backup
    latest_backup=$(
        ls -td "$BACKUP_DIR"/*"${config_type}"* 2>/dev/null | head -1
    )

    if [[ -z "$latest_backup" ]]; then
        error "No backup found for: $config_type"
        return 1
    fi

    local backup_name
    backup_name=$(basename "$latest_backup")
    
    restore_config "$backup_name" "$dry_run"
}

restore_all() {
    local dry_run="${1:-false}"

    if [[ ! -d "$BACKUP_DIR" ]]; then
        error "No backups found."
        return 1
    fi

    for backup_path in "$BACKUP_DIR"/*/; do
        local backup_name
        backup_name=$(basename "$backup_path")
        restore_config "$backup_name" "$dry_run"
    done

    success "Restore complete!"
}

show_usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
    -l, --list              List available backups
    -r, --restore           Restore specific backup (by name)
    -a, --all               Restore all backups
    -t, --type              Config type to restore (hypr, waybar, etc.)
    -n, --latest            Restore latest backup of given type
    -d, --dry-run           Show what would be restored without restoring
    -h, --help              Show this help message

Examples:
    $(basename "$0") --list
    $(basename "$0") --restore 20240101_120000_hypr
    $(basename "$0") --latest --type hypr
    $(basename "$0") --all --dry-run
EOF
}

main() {
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 0
    fi

    local dry_run="false"
    local restore_all_flag="false"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -l|--list)
                list_backups
                exit 0
                ;;
            -r|--restore)
                if [[ -z "${2:-}" ]]; then
                    error "Please specify a backup name"
                    show_usage
                    exit 1
                fi
                restore_config "$2" "$dry_run"
                shift
                ;;
            -a|--all)
                restore_all_flag="true"
                ;;
            -t|--type)
                if [[ -z "${2:-}" ]]; then
                    error "Please specify a config type"
                    show_usage
                    exit 1
                fi
                restore_latest "$2" "$dry_run"
                shift
                ;;
            -n|--latest)
                if [[ -z "${2:-}" ]]; then
                    error "Please specify a config type with --type"
                    show_usage
                    exit 1
                fi
                restore_latest "$2" "$dry_run"
                shift
                ;;
            -d|--dry-run)
                dry_run="true"
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
        shift
    done

    if [[ "$restore_all_flag" == "true" ]]; then
        restore_all "$dry_run"
    fi
}

main "$@"
