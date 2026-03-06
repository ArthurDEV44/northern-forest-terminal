# Northern Forest Terminal

A boreal-inspired terminal theme for **Linux** and **Windows**.

Dark, muted tones inspired by northern forests, aurora borealis, and morning mist.

## Color Palette

| Element | Colors |
|---------|--------|
| Background | `#0b1215` deep night bark |
| Foreground | `#c5d1cc` morning mist |
| Cursor | `#56d6b6` warm teal glow |
| Green | `#56b68a` moss / `#7ddba8` bright moss |
| Red | `#d4555e` autumn berry |
| Yellow | `#d4a35c` amber lichen |
| Blue | `#5b8fb4` twilight sky |
| Cyan | `#4dc4b0` glacier stream |
| Magenta | `#b578b4` foxglove |

## What's included

```
# Linux (Ghostty + Zsh)
ghostty/config                              # Ghostty terminal emulator
starship/starship.toml                      # Starship prompt (cross-platform)
zsh/.zshrc                                  # Zsh config with syntax highlighting colors
zsh/.zshenv                                 # Zsh environment
install.sh                                  # Linux installer

# Windows (Windows Terminal + PowerShell)
windows-terminal/northern-forest.json       # Windows Terminal color scheme
powershell/Microsoft.PowerShell_profile.ps1 # PowerShell profile with PSReadLine colors
install-windows.ps1                         # Windows installer
```

---

## Linux Setup (Ghostty + Zsh + Starship)

### Dependencies

```bash
# Fedora
sudo dnf install ghostty starship zsh zsh-autosuggestions zsh-syntax-highlighting fastfetch

# Font (required for icons)
# Install JetBrainsMono Nerd Font from https://www.nerdfonts.com/
```

### Install

```bash
git clone https://github.com/ArthurDEV44/northern-forest-terminal.git
cd northern-forest-terminal
./install.sh
```

### Manual install

```bash
cp ghostty/config ~/.config/ghostty/config
cp starship/starship.toml ~/.config/starship.toml
cp zsh/.zshrc ~/.zshrc
cp zsh/.zshenv ~/.zshenv
```

---

## Windows Setup (Windows Terminal + PowerShell + Starship)

Ghostty is not yet available on Windows. This setup uses **Windows Terminal** as the terminal emulator with **PowerShell 7** and **Starship**.

### Dependencies

Install with winget (comes with Windows 11, available for Windows 10):

```powershell
# PowerShell 7 (if not already installed)
winget install Microsoft.PowerShell

# Starship prompt
winget install Starship.Starship

# Nerd Font (required for icons)
winget install DEVCOM.JetBrainsMonoNerdFont

# Fastfetch (system info on launch)
winget install Fastfetch-cli.Fastfetch
```

### Install (one command)

```powershell
git clone https://github.com/ArthurDEV44/northern-forest-terminal.git
cd northern-forest-terminal
.\install-windows.ps1
```

The installer will:
1. Install missing dependencies via winget (Starship, Fastfetch, Nerd Font, Terminal-Icons)
2. Copy `starship.toml` to `~\.config\starship.toml`
3. Copy the PowerShell profile to `$PROFILE`
4. Inject the Northern Forest color scheme into Windows Terminal settings
5. Set it as default with JetBrainsMono Nerd Font and acrylic transparency

All existing configs are backed up before overwriting.

To skip dependency installation:

```powershell
.\install-windows.ps1 -SkipDependencies
```

### Manual install

**1. Windows Terminal color scheme**

Open Windows Terminal Settings (`Ctrl+,`) > Open JSON file, and add the contents of `windows-terminal/northern-forest.json` to the `"schemes"` array. Then set `"colorScheme": "Northern Forest"` in your profile.

Or copy the full block:

```json
"defaults": {
    "colorScheme": "Northern Forest",
    "font": { "face": "JetBrainsMono Nerd Font", "size": 13 },
    "opacity": 90,
    "useAcrylic": true
}
```

**2. Starship config**

```powershell
# Create config directory
New-Item -ItemType Directory -Force -Path "$HOME\.config"

# Copy starship config (same file as Linux)
Copy-Item starship\starship.toml "$HOME\.config\starship.toml"
```

**3. PowerShell profile**

```powershell
# Copy profile
Copy-Item powershell\Microsoft.PowerShell_profile.ps1 $PROFILE -Force

# Install required modules
Install-Module -Name Terminal-Icons -Repository PSGallery -Force

# Reload
. $PROFILE
```

### What the PowerShell profile includes

- **PSReadLine** syntax highlighting with Northern Forest colors mapped to PowerShell tokens
- **Predictive IntelliSense** from history (inline, fish-style)
- **Terminal-Icons** for file icons in directory listings
- **Key bindings**: Up/Down arrow for history search, Tab for menu completion
- **Starship** prompt initialization
- **Fastfetch** on terminal launch

### PSReadLine color mapping (Zsh → PowerShell)

| Zsh token | PowerShell token | Color |
|-----------|-----------------|-------|
| `command` | `Command` | `#56d6b6` warm teal |
| `single/double-quoted-argument` | `String` | `#7ddba8` bright moss |
| `builtin` | `Keyword` | `#4dc4b0` glacier cyan |
| `path` | `Type` | `#5b8fb4` twilight sky |
| `globbing` / `redirection` | `Operator` | `#d4a35c` amber lichen |
| `function` | `Member` | `#56b68a` moss |
| `unknown-token` | `Error` | `#d4555e` autumn berry |
| autosuggestion | `InlinePrediction` | `#3a4f4a` muted bark |

---

## Starship prompt layout

Single-line powerline prompt (shared between Linux and Windows):
- OS icon + username (left)
- Hostname + directory (left)
- Git branch & status (left)
- Language versions: Node, Rust, Go, Python, Java, PHP, Ruby, Docker (left)
- Command duration + clock (right)

The `starship.toml` is fully cross-platform. The same file works on both Zsh and PowerShell.

## Customization

**Linux (Ghostty)**:
- Transparency: `background-opacity` in `ghostty/config` (default: 0.90)
- Font size: `font-size` in `ghostty/config`

**Windows (Windows Terminal)**:
- Transparency: `"opacity"` in Windows Terminal settings (default: 90)
- Font size: `"font" > "size"` in Windows Terminal settings

**Both**:
- Prompt segments: Edit `format` in `starship/starship.toml`
- Directory aliases: Edit `[directory.substitutions]` in the starship config
- OS icon: Edit `[os.symbols]` — Windows uses `󰍲`

## License

MIT
