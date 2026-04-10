#!/bin/bash
set -euo pipefail

# Change Starship Prompt Preset

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PRESETS=(
    "starship.toml:Default Tokyo Night"
    "starship1.toml:Preset 1"
    "starship-1.toml:Preset -1"
    "starship33.toml:Preset 33"
    "starshiptrek.toml:Trek Theme"
)

show_menu() {
    echo "Select Starship preset:"
    echo ""
    
    local options=""
    for preset in "${PRESETS[@]}"; do
        local name="${preset##*:}"
        options="$options$name\n"
    done
    
    echo -e "$options" | fzf --height=~50% --prompt="Starship " --reverse --border --ansi
}

apply_preset() {
    local preset_file="$1"
    local config_dir="$HOME/.config"
    
    if [[ -f "$config_dir/$preset_file" ]]; then
        cp "$config_dir/$preset_file" "$config_dir/starship.toml"
        echo "Applied: $preset_file"
    elif [[ -f "$HOME/$preset_file" ]]; then
        cp "$HOME/$preset_file" "$config_dir/starship.toml"
        echo "Applied: $preset_file"
    else
        echo "Preset not found: $preset_file"
        exit 1
    fi
}

main() {
    if [[ -n $1 ]]; then
        # Direct argument - apply preset
        apply_preset "$1"
    else
        # Show menu
        local choice=$(show_menu)
        
        for preset in "${PRESETS[@]}"; do
            local file="${preset%%:*}"
            local name="${preset##*:}"
            if [[ "$name" == "$choice" ]]; then
                apply_preset "$file"
                exit 0
            fi
        done
        
        echo "No preset selected"
    fi
}

main "$@"