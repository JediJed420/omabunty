# Terminals Agent

**Purpose**: Handle terminal emulator and shell configuration for Omabunty

**Working Directory**: /home/jedijed/omabunty

---

## Specialization Areas

- Alacritty terminal configuration
- Kitty terminal configuration
- Zsh shell with Oh My Zsh
- Terminal color schemes (sync with Aether themes)
- Shell plugins and utilities
- Starship prompt configuration

---

## Current Tasks

### 1. Alacritty Configuration
- **Status**: Ready (imports from Omarchy/Aether theme)
- **Config Path**: `~/.config/alacritty/alacritty.toml`
- **Theme Source**: `~/.config/omarchy/current/theme/alacritty.toml` or `~/.config/aether/theme/alacritty.toml`
- **Font**: JetBrainsMono Nerd Font (size 9)
- **Window**: decorations="None", padding=14px

### 2. Kitty Configuration
- **Status**: Ready (includes Aether theme)
- **Config Path**: `~/.config/kitty/kitty.conf`
- **Theme**: Includes theme from Omarchy/Aether
- **Location**: `~/.config/aether/theme/kitty.conf`

### 3. Zsh + Oh My Zsh Setup
- **Status**: Created
- **Script**: `scripts/configs/apply-zsh.sh`
- **Features**:
  - Installs Oh My Zsh
  - Configures plugins (zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions)
  - Sets up .zshrc with starship prompt
  - Installs eza, bat as modern CLI alternatives

### 4. Starship Prompt Configuration
- **Status**: Ready
- **Config Path**: `config/starship.toml` → copied to `~/.config/starship.toml`
- **Format**: Segmented with directory, git branch, git status

### 5. Terminal Theme Sync
- **Status**: Ready
- **Flow**: Aether generates themes → copies to ~/.config/aether/theme/ → terminals import

---

## Review Summary

### Configs Reviewed
| Config | Status | Notes |
|--------|--------|-------|
| `config/alacritty/alacritty.toml` | Ready | Imports from theme, uses Omarchy/Aether |
| `config/kitty/kitty.conf` | Ready | Includes Aether theme |
| `config/starship.toml` | Ready | Basic config with git styling |

### Scripts Created/Adapted
| Script | Status | Notes |
|--------|--------|-------|
| `scripts/configs/apply-alacritty.sh` | Ready | Exports Omarchy/Aether theme to alacritty.toml |
| `scripts/configs/apply-kitty.sh` | Fixed | Now only includes OMARCHY_THEME (not duplicate) |
| `scripts/configs/apply-zsh.sh` | Fixed | Fixed starship path to `~/.config/starship.toml`, fixed apt install flags |
| `scripts/configs/apply-terminals.sh` | Ready | Applies all terminal configs |

### Issues Found
1. **Kitty**: Had duplicate include for both themes - fixed
2. **Starship path**: Referenced wrong path `starship33.toml` - fixed to `starship.toml`
3. **Install flags**: eza/bat install used wrong apt flags (`-y` at end vs beginning) - fixed
4. **Dependencies**: Added starship, eza, bat to install-deps.sh terminal section

---

## Validation Commands

```bash
# Test terminal scripts exist and are executable
ls -la ./scripts/configs/apply-*.sh

# Test Alacritty config
alacritty --version

# Test Kitty config
kitty --version

# Test Zsh
zsh --version

# Test Starship
starship --version

# Generate theme and apply configs
aether --generate wallpaper.jpg
./scripts/configs/apply-terminals.sh

# Verify configs applied
ls -la ~/.config/alacritty/alacritty.toml
ls -la ~/.config/kitty/kitty.conf
cat ~/.config/starship.toml
```

---

## Usage

```bash
# Apply terminal configs
./scripts/configs/apply-terminals.sh

# Apply Alacritty only
./scripts/configs/apply-alacritty.sh

# Apply Kitty only
./scripts/configs/apply-kitty.sh

# Apply Zsh + Oh My Zsh
./scripts/configs/apply-zsh.sh

# Generate theme with Aether
aether --generate wallpaper.jpg
```

---

## Testing

- Test Alacritty with Omarchy theme
- Test Kitty with Aether-generated theme
- Verify Zsh plugins load correctly
- Test Starship prompt rendering
- Verify theme sync after Aether generation

---

## File Structure

```
omabunty/
├── scripts/
│   └── configs/
│       ├── apply-terminals.sh    # Apply all terminal configs
│       ├── apply-alacritty.sh    # Apply Alacritty config
│       ├── apply-kitty.sh        # Apply Kitty config
│       ├── apply-zsh.sh          # Install and apply Zsh/OMZ
│       └── apply-hyprland.sh     # Hyprland config (existing)
├── agents/
│   ├── installer-iso-agent.md     # Installer/ISO agent
│   └── terminals-agent.md        # This file
└── configs/                      # Config templates directory
```

---

## Notes

- **Ghostty**: Omarchy uses Ghostty which is not available on Ubuntu → using Alacritty/Kitty instead
- **Ubuntu packages**: Some packages may have different names (e.g., starship, eza, bat available via apt)
- **Theme sync**: Requires Aether to be installed and theme generated

---

## References

- Omarchy Alacritty: `~/.config/omarchy/current/theme/alacritty.toml`
- Omarchy Kitty: `~/.config/omarchy/current/theme/kitty.conf`
- Aether themes: `~/.config/aether/theme/`
- Starship config: `config/starship.toml` (template)