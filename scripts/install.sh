#!/bin/bash

# Detect platform
platform="unknown"
case "$(uname -s)" in
    Darwin*)   platform="macos";;
    Linux*)    platform="linux";;
    MSYS*)     platform="windows";;
    MINGW*)    platform="windows";;
esac

# Base directory for dotfiles
DOTFILES="$HOME/.dotfiles"

# Function to backup existing configs
backup_configs() {
    local backup_dir="$HOME/.config.bak.$(date +%Y%m%d_%H%M%S)"
    echo "Creating backup of existing configs in $backup_dir"
    mkdir -p "$backup_dir"

    # Backup existing configs if they exist
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$backup_dir/"
    [ -d "$HOME/.config/wezterm" ] && cp -r "$HOME/.config/wezterm" "$backup_dir/"
    [ -f "$HOME/.tmux.conf" ] && cp "$HOME/.tmux.conf" "$backup_dir/"
    [ -d "$HOME/.config/nvim" ] && cp -r "$HOME/.config/nvim" "$backup_dir/"
    [ -f "$HOME/.config/starship.toml" ] && cp "$HOME/.config/starship.toml" "$backup_dir/"

    # Remove existing configs after backup
    rm -f "$HOME/.zshrc"
    rm -rf "$HOME/.config/wezterm"
    rm -f "$HOME/.tmux.conf"
    rm -rf "$HOME/.config/nvim"
    rm -f "$HOME/.config/starship.toml"
}

# Check for stow
if ! command -v stow >/dev/null 2>&1; then
    echo "Error: stow is not installed. Please install it first:"
    case "$platform" in
        "macos")   echo "  brew install stow";;
        "linux")   echo "  sudo apt install stow";;
        "windows") echo "  pacman -S stow";;
    esac
    exit 1
fi

# Backup existing configs
backup_configs

# Create necessary directories
mkdir -p "$HOME/.config/"{wezterm,nvim/plugin,starship}

# Common stow packages
packages=(zsh wezterm tmux nvim starship)

# Unstow any existing configurations
for package in "${packages[@]}"; do
    stow -D "$package" 2>/dev/null
done

# Stow all packages
echo "Stowing configurations..."
for package in "${packages[@]}"; do
    if stow -v --adopt -t "$HOME" "$package" 2>/dev/null || stow -v -t "$HOME" "$package"; then
        echo "✓ Successfully stowed $package"
    else
        echo "✗ Failed to stow $package"
        echo "Try removing any existing configuration files in $HOME and try again"
    fi
done

# Platform-specific post-install steps
case "$platform" in
    "macos")
        echo "Configuring macOS specific settings..."
        # Add macOS specific configurations here
        ;;
    "linux")
        echo "Configuring Linux specific settings..."
        # Add Linux specific configurations here
        ;;
    "windows")
        echo "Configuring Windows specific settings..."
        # Add MSYS2/Windows specific configurations here
        ;;
esac

echo "Installation complete!"
echo "Original configs have been backed up to ~/.config.bak.*"
echo "You can remove the backup after verifying everything works."
