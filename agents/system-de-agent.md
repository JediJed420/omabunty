# System/DE Agent - Omabunty

## Display Manager

### SDDM Configuration Created

**Config File**: `config/sddm/sddm.conf`
- Wayland session enabled
- Hyprland as default session
- Breeze theme (default)
- Auto-login can be enabled by setting `User=username` in `[Autologin]`

**Apply Script**: `scripts/configs/apply-sddm.sh`
- Installs SDDM + breeze theme
- Enables SDDM service
- Copies config to `~/.config/sddm/` and `/etc/sddm.conf.d/`

### Greetd/Tuigreet (Omarchy Reference)
- Omarchy uses greetd + tuigreet (tty-based)
- Ubuntu: SDDM is more compatible with GNOME stack
- Transition complete

## Systemd Adaptations

### User Services Created
- `config/systemd/user/omabunty-battery-monitor.service`
- `config/systemd/user/omabunty-battery-monitor.timer`

### Changes from Omarchy
- `Description` → "Omabunty" (was "Omarchy")
- `ExecStart` → `%h/.local/share/omabunty/bin/omabunty-battery-monitor`
- Added `Environment=XDG_CURRENT_DESKTOP=Hyprland`
- Added `[Install]` section for WantedBy

### Install Commands
```bash
mkdir -p ~/.local/share/omabunty/bin
cp config/systemd/user/omabunty-battery-monitor.service ~/.config/systemd/user/
cp config/systemd/user/omabunty-battery-monitor.timer ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now omabunty-battery-monitor.timer
```

## Environment Configuration

### Created
**File**: `config/environment.d/omabunty.conf`

Sets:
- `XDG_CURRENT_DESKTOP=Hyprland`
- `XDG_SESSION_TYPE=wayland`
- `GDK_BACKEND=wayland`
- `QT_QPA_PLATFORM=wayland;xcb`
- `SDL_VIDEODRIVER=wayland`
- `MOZ_ENABLE_WAYLAND=1`
- `CLUTTER_BACKEND=wayland`

### Install
```bash
cp config/environment.d/omabunty.conf ~/.config/environment.d/
```

## Validation Commands

```bash
# Test SDDM config
sddm --test-mode --verbose

# Verify systemd services
systemctl --user status omabunty-battery-monitor.timer
systemctl --user list-timers

# Check environment
cat /etc/environment
# or
echo $XDG_CURRENT_DESKTOP
```

## Ubuntu-Specific Integrations

- SDDM replaces greetd (tty login)
- Breeze theme matches Ubuntu/GNOMe aesthetic
- systemd user services compatible with Ubuntu
- Environment config for Wayland session

## Notes

- Autologin disabled by default for security
- Session dir includes both xsessions and wayland-sessions
- HiDPI support enabled for Wayland
- HandleLid=true for laptop display handling
