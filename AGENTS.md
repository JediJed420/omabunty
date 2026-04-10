# JediJed OS

## Install

```bash
sudo ./scripts/install-deps.sh
sudo ./scripts/install-all.sh
./scripts/omarchy-menu
./scripts/configs/apply-hyprland.sh
./scripts/configs/apply-terminals.sh
```

## Key Facts

- **Base**: Ubuntu 24.04 LTS (Omarchy = Arch, we = Ubuntu)
- **Display Manager**: SDDM (Omarchy = greetd+tuigreet)
- **Window Manager**: Hyprland (Wayland only, not X11)
- **Configs**: `config/` → copied to `~/.config/`
- **Themes**: `~/.config/aether/theme/`

## Code Style

- Shebang: `#!/bin/bash` (never `#!/usr/bin/env bash`)
- Indent: 2 spaces, no tabs
- Conditionals: `[[ ]]` for string/file, `(( ))` for numeric
- Backup configs before applying

## Testing

Agent outputs commands → user runs manually → agent iterates on feedback.