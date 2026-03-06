# Northern Forest Terminal

A boreal-inspired terminal theme for **Ghostty + Starship + Zsh** on Fedora Linux.

Dark, muted tones inspired by northern forests, aurora borealis, and morning mist.

## Preview

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
ghostty/config        # Ghostty terminal emulator config
starship/starship.toml # Starship prompt (powerline style)
zsh/.zshrc            # Zsh config with matching syntax highlighting colors
zsh/.zshenv           # Zsh environment (cargo)
install.sh            # One-command installer with backup
```

## Dependencies

Install these before using the theme:

```bash
# Fedora
sudo dnf install ghostty starship zsh zsh-autosuggestions zsh-syntax-highlighting fastfetch

# Font (required for icons)
# Install JetBrainsMono Nerd Font from https://www.nerdfonts.com/
```

## Install

```bash
git clone https://github.com/ArthurDEV44/northern-forest-terminal.git
cd northern-forest-terminal
./install.sh
```

The installer backs up your existing configs before overwriting.

## Manual install

If you prefer to copy files manually:

```bash
# Ghostty
cp ghostty/config ~/.config/ghostty/config

# Starship
cp starship/starship.toml ~/.config/starship.toml

# Zsh
cp zsh/.zshrc ~/.zshrc
cp zsh/.zshenv ~/.zshenv
```

## Starship prompt layout

Single-line powerline prompt with:
- OS icon + username (left)
- Hostname + directory (left)
- Git branch & status (left)
- Language versions: Node, Rust, Go, Python, Java, PHP, Ruby, Docker (left)
- Command duration + clock (right)

## Customization

- **Transparency**: Adjust `background-opacity` in `ghostty/config` (default: 0.90)
- **Font size**: Change `font-size` in `ghostty/config`
- **Prompt segments**: Edit `format` in `starship/starship.toml`
- **Directory aliases**: Edit `[directory.substitutions]` in the starship config

## License

MIT
