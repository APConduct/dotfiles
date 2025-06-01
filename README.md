# me files :bird:

Cross-platform development environment configuration managed with GNU Stow.

## Prerequisites

- Git
- GNU Stow
- Zsh + Oh My Zsh
- Starship
- WezTerm
- Tmux
- Neovim

### Install Prerequisites

macOS:
```bash
brew install stow zsh tmux neovim starship
brew install --cask wezterm
```

Linux (Ubuntu/Mint):
```bash
sudo apt install stow zsh tmux neovim
curl -sS https://starship.rs/install.sh | sh
```

MSYS2:
```bash
pacman -S stow zsh tmux neovim starship
```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/APConduct/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Run the install script:
```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

## Local Configuration

Machine-specific configurations can be added through local config files:

- `~/.zshrc.local` - Shell customization
- `~/.config/wezterm/wezterm.local.lua` - WezTerm settings
- `~/.tmux.conf.local` - Tmux configuration

Example templates are provided in the `templates/` directory:

```bash
# Copy and customize the templates you need
cp templates/zshrc.local.example ~/.zshrc.local
cp templates/wezterm.local.example.lua ~/.config/wezterm/wezterm.local.lua
cp templates/tmux.local.example.conf ~/.tmux.conf.local
```

These local configuration files are not tracked by git, allowing for machine-specific customization.
