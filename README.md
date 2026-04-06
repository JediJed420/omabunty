# Omabunty

**Omabunty** is an Ubuntu-based Linux distribution that replicates [Omarchy](https://github.com/basecamp/omarchy) with all the same UI features and built-in programs. Paid programs are replaced with free alternatives offering equivalent functionality.

## Overview

- **Base**: Ubuntu 24.04 LTS
- **Window Manager**: Hyprland (Wayland)
- **Shell**: Zsh with Oh My Zsh
- **Theme**: Aether (wallpaper-based theme generation)
- **Menu**: Omabunty Menu (fzf-based TUI)

## Why Omabunty?

Omarchy is an Arch-based distribution. Omabunty brings the same beautiful, modern experience to Ubuntu users with:

- Same UI/UX as Omarchy (Hyprland, Waybar, Rofi)
- Same toolset (Alacritty, Kitty, LazyVim, Btop)
- Free alternatives to paid software (GIMP, Audacity, LibreOffice, Marktext)
- Easier installation on existing Ubuntu systems

## Quick Start

```bash
# Clone the repository
git clone https://github.com/JediJed420/omabunty.git
cd omabunty

# Full installation (all core components)
sudo ./scripts/install-all.sh

# Or install dependencies only
sudo ./scripts/install-deps.sh

# Run the Omabunty Menu
./scripts/omarchy-menu

# Or install specific components
./scripts/configs/apply-hyprland.sh
./scripts/configs/apply-lazyvim.sh
./scripts/configs/apply-terminals.sh
```

## Features

### Core Components
- **Window Manager**: Hyprland with custom keybindings
- **Status Bar**: Waybar with modules (cpu, memory, battery, etc.)
- **Terminal**: Alacritty & Kitty with theme synchronization
- **Shell**: Zsh with Oh My Zsh + Starship prompt
- **Editor**: LazyVim (Neovim preset)
- **Menu**: Omabunty Menu (Super+M keybinding)

### Free Alternatives to Paid Software
| Paid | Free Alternative |
|------|------------------|
| Adobe Photoshop | GIMP |
| Adobe Audition | Audacity |
| Microsoft Office | LibreOffice |
| Typora | Marktext |
| Activity Monitor | btop |

### Application Scripts
Located in `scripts/configs/apply-*.sh`:
- `apply-hyprland.sh` - Hyprland window manager
- `apply-waybar.sh` - Status bar
- `apply-sddm.sh` - Login manager
- `apply-terminals.sh` - Terminal emulators
- `apply-lazyvim.sh` - Neovim/LazyVim
- `apply-rofi.sh` - App launcher
- `apply-picom.sh` - Compositor
- `apply-zsh.sh` - Shell
- `apply-gimp.sh` - Image editor
- `apply-audacity.sh` - Audio editor
- `apply-libreoffice.sh` - Office suite
- `apply-marktext.sh` - Markdown editor
- `apply-btop.sh` - System monitor
- `apply-fastfetch.sh` - System info
- `apply-lazygit.sh` - Git TUI
- `apply-xournalpp.sh` - Note-taking

### Installer Scripts
Located in `scripts/`:
- `install-deps.sh` - Install system dependencies
- `install-all.sh` - Install all core components
- `install-menu.sh` - Install menu launcher
- `omarchy-menu` - Main menu TUI
- `omabunty-install-terminal.sh` - Install terminal emulators
- `omabunty-install-dev-env.sh` - Install dev environments
- `omabunty-tui-install.sh` - Install TUI apps
- `omabunty-update.sh` - Update system & Omabunty

## Keybindings

- `Super+M` - Open Omabunty Menu
- `Super+Space` - App launcher (Rofi)
- `Super+Return` - Terminal (Alacritty)
- `Super+N` - Editor (LazyVim)

## Project Structure

```
omabunty/
├── config/              # Default configurations
├── scripts/
│   ├── configs/        # Config appliers (apply-*.sh)
│   ├── omabunty-*.sh   # Utility scripts
│   └── omarchy-menu    # Menu TUI
├── applications/       # Desktop entries
├── iso/               # ISO build tools
└── agents/            # Agent documentation
```

## Documentation

- [AGENTS.md](AGENTS.md) - Guidelines for agents
- [agents/](agents/) - Individual agent documentation

## License

MIT License - See [LICENSE](LICENSE)

## Links

- [Omabunty GitHub](https://github.com/JediJed420/omabunty)
- [Omarchy](https://github.com/basecamp/omarchy)
- [Aether Theme Manager](https://github.com/luMVz/aether)