#!/bin/bash

# Colors - using your preferred palette
BLUE="\033[34m"          # Regular blue
PALE_BLUE="\033[38;2;135;206;235m" # Pale bright blue (#87ceeb)
DENIM="\033[38;2;70;130;180m"      # Denim blue (#4682b4)
YELLOW="\033[38;2;240;230;140m"    # Pale yellow (#f0e68c)
BRIGHT_YELLOW="\033[38;2;255;245;157m" # Bright pale yellow (#fff59d)
RED="\033[38;2;220;20;60m"         # Cherry red (#dc143c)
RESET="\033[0m"

# Paths
DOTFILES="$HOME/.dotfiles"
ASCII_DIR="$DOTFILES/ascii"
FASTFETCH_CONFIG="$HOME/.config/fastfetch"

# Function to display random ASCII art
show_random_art() {
    local art_files=("$ASCII_DIR"/*.txt)
    if [ ${#art_files[@]} -gt 0 ]; then
        local random_art=${art_files[$RANDOM % ${#art_files[@]}]}
        # Check if file exists before displaying
        if [[ -f "$random_art" ]]; then
            # Add a glitch effect by alternating colors
            if [[ "$(basename "$random_art")" == "pigeon.txt" ]]; then
                echo -e "${PALE_BLUE}"
            else
                echo -e "${DENIM}"
            fi
            cat "$random_art"
            echo -e "${RESET}"
        fi
    fi
}

# Function to display figlet text with effects
show_figlet() {
    local text="$1"
    local font="${2:-slant}"
    if command -v figlet >/dev/null && command -v lolcat >/dev/null; then
        figlet -f "$font" "$text" | lolcat -F 0.5
    elif command -v figlet >/dev/null; then
        echo -e "${PALE_BLUE}"
        figlet -f "$font" "$text"
        echo -e "${RESET}"
    else
        echo -e "${YELLOW}$text${RESET}"
    fi
}

# Function to show system info
show_system_info() {
    local config="${1:-minimal}"
    if command -v fastfetch >/dev/null; then
        fastfetch --load-config "$FASTFETCH_CONFIG/$config.jsonc"
    else
        echo -e "${RED}fastfetch not installed${RESET}"
    fi
}

# Get time-based greeting
get_greeting() {
    local hour=$(date +%H)
    if [ $hour -ge 5 ] && [ $hour -lt 12 ]; then
        echo "Good morning"
    elif [ $hour -ge 12 ] && [ $hour -lt 18 ]; then
        echo "Good afternoon"
    elif [ $hour -ge 18 ] && [ $hour -lt 22 ]; then
        echo "Good evening"
    else
        echo "Good night"
    fi
}

# Main welcome sequence
if [[ $- == *i* ]] && [ -z "$TMUX" ]; then
    clear

    # Show random ASCII art, if available in the 'ascii' directory
    # show_random_art

    # Get greeting based on time of day
    greeting=$(get_greeting)

    # Show personalized welcome (using small font for compactness)
    # show_figlet "${greeting}, Perry" "small"
    echo
    show_system_info
    echo
fi
