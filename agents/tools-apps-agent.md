# Tools/Apps Agent - Documentation

## Application Mappings (Omarchy → Ubuntu)

| Omarchy App | Ubuntu Equivalent | Status |
|------------|------------------|--------|
| Ghostty | Alacritty/Kitty | Already configured (terminals-agent) |
| mpv | mpv | Available via apt |
| imv | imv | Available via apt |
| Brave/Chromium | chromium-browser | Available via apt/flatpak |

## Free Alternatives Identified

### Paid Apps to Replace

| Paid App | Free Alternative | Notes |
|----------|------------------|-------|
| Typora | Marktext | Available via flatpak |
| Adobe Photoshop | GIMP | Free image editor |
| Adobe Audition | Audacity | Free audio editor |
| Microsoft Office | LibreOffice | Free office suite |
| Activity Monitor | btop | Free system monitor |
| Neofetch | fastfetch | System info display |

## Scripts Created

| Script | Description |
|--------|-------------|
| `apply-gimp.sh` | Installs GIMP (free image editor) |
| `apply-audacity.sh` | Installs Audacity (free audio editor) |
| `apply-libreoffice.sh` | Installs LibreOffice (free office suite) |
| `apply-marktext.sh` | Installs Marktext (free markdown editor) |
| `apply-media.sh` | Installs mpv and imv |
| `apply-btop.sh` | Installs btop (system monitor) |
| `apply-fastfetch.sh` | Installs fastfetch (system info) |
| `apply-lazygit.sh` | Installs lazygit (git TUI) |
| `apply-xournalpp.sh` | Installs Xournal++ (note-taking) |

### Usage

```bash
# Install all tools
./scripts/configs/apply-gimp.sh
./scripts/configs/apply-audacity.sh
./scripts/configs/apply-libreoffice.sh
./scripts/configs/apply-marktext.sh
./scripts/configs/apply-media.sh
./scripts/configs/apply-btop.sh
./scripts/configs/apply-fastfetch.sh
./scripts/configs/apply-lazygit.sh
./scripts/configs/apply-xournalpp.sh
```

### Or install all at once

```bash
# Apply all tool configs
for script in ./scripts/configs/apply-{gimp,audacity,libreoffice,marktext,media,btop,fastfetch,lazygit,xournalpp}.sh; do
    bash "$script"
done
```

## Validation Commands

Test that each application is installed and runs correctly:

```bash
# Test GIMP
which gimp && gimp --version

# Test Audacity
which audacity && audacity --version

# Test LibreOffice
which libreoffice && libreoffice --version

# Test Marktext
which marktext || flatpak list | grep marktext

# Test mpv
which mpv && mpv --version

# Test btop
which btop && btop --version

# Test fastfetch
which fastfetch && fastfetch --version

# Test lazygit
which lazygit && lazygit --version

# Test Xournal++
which xournalpp && xournalpp --version
```

## Desktop Entries

Desktop entries in `applications/`:
- `mpv.desktop` - Media player
- `imv.desktop` - Image viewer
- `marktext.desktop` - Markdown editor (Typora replacement)
- `typora.desktop` - (kept for reference, but marktext is preferred)

## Config Locations

| App | Config Path |
|-----|-------------|
| GIMP | `~/.config/GIMP/` |
| Audacity | `~/.config/audacity/` |
| LibreOffice | `~/.config/libreoffice/` |
| Marktext | `~/.config/marktext/` |
| mpv | `~/.config/mpv/` |
| btop | `~/.config/btop/` |
| fastfetch | `~/.config/fastfetch/` |
| lazygit | `~/.config/lazygit/` |
| Xournal++ | `~/.config/xournalpp/` |