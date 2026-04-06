# AGENTS.md

Guidelines for agentic coding agents working on the Omabunty project.

## Project Overview

Omabunty is an Ubuntu-based Linux distribution that replicates Omarchy (https://github.com/basecamp/omarchy) with all the same UI features and built-in programs. Paid programs are replaced with free alternatives offering equivalent functionality.

**GitHub**: https://github.com/JediJed420/omabunty

## Project Goals

1. Replicate Omarchy UI and functionality on Ubuntu 24.04 LTS
2. Replace paid programs with free alternatives (GIMP→Photoshop, Audacity→Audition, LibreOffice→MS Office)
3. Include minor improvements where beneficial
4. Create .iso and install script for fresh installation or Ubuntu upgrade
5. Publish to GitHub for community use

## Tech Stack

- **Base**: Ubuntu 24.04 LTS (Omarchy is Arch-based, we adapt to Ubuntu)
- **Window Manager**: Hyprland (Wayland)
- **Shell**: Zsh with Oh My Zsh
- **Terminal**: Alacritty, Kitty
- **Theme Management**: Aether
- **Bar**: Waybar
- **Launcher**: Rofi/Wofi

## Reference Configurations

- **Official Omarchy**: `/home/jedijed/omabunty/config/` (cloned from basecamp/omarchy dev branch)
- **User's Omarchy**: `~/.config/omarchy/` (current theme: retro-82)
- **Aether Themes**: `~/.config/aether/theme/`

## Build & Setup Commands

### Initial Setup (Ubuntu 24.04)

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install core dependencies
./scripts/install-deps.sh

# Apply Omabunty configuration
./install.sh
```

### Configuration Management

```bash
# Apply all configs
./scripts/apply-configs.sh

# Apply specific app config
./scripts/configs/apply-hyprland.sh
./scripts/configs/apply-waybar.sh
./scripts/configs/apply-terminals.sh

# Apply theme (requires Aether)
aether --generate wallpaper.jpg
```

### ISO Creation

```bash
# Build ISO (requires squashfs-tools, genisoimage)
cd iso && ./build-iso.sh
```

## Code Style Guidelines

### Shell Scripts (from Omarchy AGENTS.md, adapted)

- **Indentation**: 2 spaces, no tabs
- **Conditionals**: Use `[[ ]]` for string/file tests, `(( ))` for numeric tests
- **Quoting**: Quote strings with spaces, don't quote variables in `[[ ]]`
- **Shebang**: `#!/bin/bash` consistently (never `#!/usr/bin/env bash`)
- **Naming**: All commands start with `omabunty-` prefix
  - `cmd-` - check if commands exist
  - `pkg-` - package management
  - `refresh-` - copy default config to `~/.config/`
  - `restart-` - restart component
  - `theme-` - theme management

### Helper Commands

```bash
omabunty-cmd-missing <command>   # Check if command exists
omabunty-pkg-missing <package>   # Check if package installed
omabunty-refresh-config <path>   # Copy config with backup
```

### Configuration Files

- **Format**: Follow app's native format (YAML, TOML, Lua, etc.)
- **Location**: `config/` → copied to `~/.config/`
- **Templates**: `default/themed/*.tpl` with `{{ variable }}` placeholders

### Git & Versioning

```bash
# Standard commit message format
git commit -m "description: what changed"

# Branch naming
feature/description
bugfix/description
```

## Project Structure

```
omabunty/
├── AGENTS.md              # This file
├── install.sh            # Main installer script
├── boot.sh               # Boot configuration
├── config/               # Default configs (Omarchy source)
│   ├── hypr/            # Hyprland window manager
│   ├── waybar/          # Status bar
│   ├── alacritty/       # Terminal
│   ├── kitty/           # Terminal
│   ├── starship.toml    # Shell prompt
│   └── ...              # Other app configs
├── scripts/              # Installation and setup scripts
│   ├── configs/         # Config appliers
│   ├── install-deps.sh  # Dependencies installer
│   ├── fresh-install.sh # Fresh Ubuntu install
│   └── upgrade.sh       # In-place upgrade
├── iso/                  # ISO build tools
├── applications/        # Desktop entries
├── themes/              # Theme definitions
├── bin/                 # Utility commands
├── agents/              # Agent documentation
│   ├── ui-theme-agent.md
│   ├── terminals-agent.md
│   ├── system-de-agent.md
│   ├── tools-apps-agent.md
│   ├── installer-iso-agent.md
│   └── config-management-agent.md
└── user-configs/        # Reference: user's Omarchy configs
```

## Core Components

### Display Manager
- **Omarchy**: greetd + tuigreet
- **Omabunty**: SDDM (simpler, Ubuntu-compatible)

### UI Elements
- Waybar (status bar)
- Rofi/Wofi (app launcher)
- Picom (compositor)
- wlogout (lock screen)

### Terminals
- Alacritty
- Kitty
- Ghostty (Omarchy uses, not available on Ubuntu - use Alacritty/Kitty instead)

### Editors
- Neovim
- Typora (paid - consider Marktext as free alternative)

### Tools
- Btop (system monitor)
- GIMP (image editor - free alternative)
- Audacity (audio editor - free alternative)
- LibreOffice (office suite - free alternative)

## Development Workflow

1. Test changes in isolated environment (VM)
2. Use configuration backup before applying changes
3. Reference Omarchy configs in `config/` as base
4. Reference user's configs in `~/.config/omarchy/` for customizations
5. Document any non-standard configurations
6. Test on fresh Ubuntu 24.04 installation before release

## Important Notes

- **Ubuntu vs Arch**: Omarchy is Arch-based, Omabunty is Ubuntu-based
  - Package manager: pacman → apt
  - AUR packages → various (flatpak, snap, manual)
- **All configs** are in `~/.config/`
- **Theme outputs** go to `~/.config/aether/theme/`
- **Back up** configs before running install scripts
- Some features require Wayland session (not X11)

## Common Tasks

### Adding new application support
1. Create config template in `config/<app>/`
2. Create apply script in `scripts/configs/`
3. Add to main installer
4. Test on fresh install

### Modifying theme
1. Update Aether blueprint or template
2. Generate theme: `aether --generate <wallpaper>`
3. Test across all apps
4. Commit changes

### Building ISO
1. Run `./iso/build-iso.sh`
2. Test with VM
3. Verify all configs apply correctly

## Testing

Without VM available, testing workflow:
1. Agent creates config files
2. Agent outputs validation commands
3. User runs commands manually on this system
4. Report results back to agent
5. Agent iterates based on feedback

## Agent Team

### UI/Theme Agent
- Focus: Hyprland, Waybar, Aether, Rofi/Wofi, Picom, GTK
- Reference: `~/.config/omarchy/current/theme/`, `config/waybar/`, `config/hypr/`

### Terminals Agent
- Focus: Alacritty, Kitty, Zsh, Starship
- Reference: `config/alacritty/`, `config/kitty/`, `config/starship.toml`

### System/DE Agent
- Focus: SDDM, systemd, GNOME integration
- Replace greetd/tuigreet with SDDM

### Tools/Apps Agent
- Focus: GIMP, Audacity, LibreOffice, free alternatives
- Map Omarchy apps to Ubuntu equivalents

### Installer/ISO Agent
- Focus: Install scripts, ISO building
- Enhance for Ubuntu 24.04

### Config Management Agent
- Focus: Backup/restore, dotfiles sync
- Handle Ubuntu paths