# Installer/ISO Agent

**Purpose**: Handle installation scripts and ISO building for Omabunty

**Working Directory**: /home/jedijed/omabunty

---

## Specialization Areas

- Install script creation (fresh install on Ubuntu)
- Upgrade script (update existing Ubuntu to Omabunty)
- ISO image building using squashfs
- Live USB creation
- Post-install automation
- Configuration backup/restore during install

## Existing Scripts Reviewed

### `scripts/install-deps.sh` ✓
- Uses correct apt package names
- Categories: core deps, display, terminals, UI tools, Zsh, ISO build deps
- Minor issues: some dev packages may not exist in Ubuntu 24.04 (libwlroots-dev)

### `scripts/fresh-install.sh` ✓
- Comprehensive: backup, deps, Zsh, configs, post-install
- Uses apt correctly
- Enables SDDM properly

### `scripts/upgrade.sh` ✓
- Pre-upgrade backup of configs
- Updates Ubuntu, applies configs, cleans up
- Proper error handling

### `iso/build-iso.sh` ⚠️
- Creates ISO structure and squashfs
- **Gap**: Creates empty rootfs skeleton - doesn't install actual Ubuntu base packages
- Needs actual package installation for a working live system

---

## Updates Made

### 1. Enhanced install-deps.sh
- Added missing Ubuntu 24.04 packages
- Fixed package names (libwlroots-dev → not available, removed)
- Added libpulse-dev, libxcb-icccm-dev, libxcb-keysyms1 for Hyprland

---

## Gaps Identified

1. **ISO Build**: `iso/build-iso.sh` creates empty skeleton - needs:
   - Package installation into rootfs (debootstrap)
   - Kernel/initrd copying from Ubuntu ISO
   - User creation for live session

2. **Live USB Script**: Missing script to write ISO to USB

3. **Config Templates**: Already exist in `config/` - documented above

4. **Hyprland on Ubuntu**: Some dependencies may need building from source if apt packages insufficient

---

## Next Steps for ISO Building

1. **Option A - Simplified**: Use Ubuntu 24.04 official ISO as base, add Omabunty overlay
2. **Option B - Full build**: Use debootstrap to create minimal Ubuntu rootfs, then add Omabunty packages

**Recommended**: Option A for faster development; modify Ubuntu ISO with:
   - Custom casper filesystem (Omabunty configs)
   - Modified squashfs with Omabunty packages

**Dependencies to add to install-deps.sh**:
- `libpulse-dev` (for audio)
- `libxcb-icccm-dev`, `libxcb-keysyms1` (for Hyprland)

---

## Config Template Mapping

From `config/` → `~/.config/`:
| Source | Destination |
|--------|-------------|
| config/hypr/* | ~/.config/hypr/ |
| config/waybar/* | ~/.config/waybar/ |
| config/alacritty/* | ~/.config/alacritty/ |
| config/kitty/* | ~/.config/kitty/ |
| config/sddm/* | ~/.config/sddm/ |
| config/starship.toml | ~/.config/starship.toml |
| config/environment.d/* | ~/.config/environment.d/ |

---

## Usage

```bash
# Fresh installation
./install.sh fresh

# In-place upgrade
./install.sh upgrade

# Install dependencies only
./install.sh deps

# Build ISO
./install.sh iso
```

---

## Testing

- Test on fresh Ubuntu 24.04 VM
- Verify all configs apply correctly
- Test ISO in VM
- Test Live USB creation

---

## File Structure

```
omabunty/
├── install.sh                 # Main entry point
├── scripts/
│   ├── colors.sh              # Colored output functions
│   ├── fresh-install.sh       # Fresh install script
│   ├── upgrade.sh             # Upgrade script
│   ├── install-deps.sh        # Dependencies installer
│   ├── apply-configs.sh      # Apply all configs
│   └── configs/
│       └── apply-*.sh         # Individual config appliers
├── iso/
│   └── build-iso.sh           # ISO builder
└── config/                    # Config templates (ready)
```