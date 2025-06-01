# ~/.zshrc
# Cross-platform Zsh configuration for development with WezTerm + Tmux + Starship
# Designed for use with GNU Stow dotfile management

# Platform detection
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PLATFORM="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export PLATFORM="linux"
elif [[ "$OSTYPE" == "msys" ]]; then
    export PLATFORM="windows"
fi

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="" # Using Starship instead

# Essential plugins
plugins=(
    git                     # Git integration and aliases
    tmux                    # Tmux integration
    colored-man-pages      # Colorized man pages
    command-not-found      # Package suggestions
    zsh-autosuggestions    # Fish-like suggestions
    zsh-syntax-highlighting # Syntax highlighting
    z                      # Directory jumping
    fzf                    # Fuzzy finder integration
)

source $ZSH/oh-my-zsh.sh

# Modern CLI tool replacements
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -la --icons'
    alias lt='eza --tree --icons'
    alias la='eza -a --icons'
elif command -v exa &> /dev/null; then
    alias ls='exa --icons'
    alias ll='exa -la --icons'
    alias lt='exa --tree --icons'
    alias la='exa -a --icons'
fi

command -v bat &> /dev/null && alias cat='bat'
command -v fd &> /dev/null && alias find='fd'
command -v rg &> /dev/null && alias grep='rg'
command -v delta &> /dev/null && export GIT_PAGER='delta'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gf='git fetch'
alias gpl='git pull'
alias grb='git rebase'

# Tmux shortcuts
alias tl='tmux list-sessions'
alias ta='tmux attach -t'
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias ~='cd ~'

# Development shortcuts
alias mk='make'
alias mkd='make debug'
alias mkr='make release'
alias mkt='make test'
alias mkc='make clean'

# Platform-specific configurations
case $PLATFORM in
    "windows")
        # MSYS2 specific
        export PATH="/ucrt64/bin:/clang64/bin:$PATH"
        alias explore='explorer .'
        alias open='start'

        # MSYS2 development paths
        export MSYS2_HOME="/c/msys64"
        export MINGW_HOME="$MSYS2_HOME/mingw64"

        # MSYS2 fzf location (after pacman -S fzf)
        export FZF_BASE="/usr/share/fzf"
        ;;
    "macos")
        # macOS specific
        export PATH="/opt/homebrew/bin:$PATH"
        export HOMEBREW_NO_AUTO_UPDATE=1
        alias open='open'

        # Handle Homebrew
        if [ -f "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            export FZF_BASE="$(brew --prefix)/opt/fzf"
        fi
        ;;
    "linux")
        # Linux specific
        alias open='xdg-open'
        export PATH="$HOME/.local/bin:$PATH"
        # Check common fzf installation locations on Linux
        if [ -d "/usr/share/fzf" ]; then
            export FZF_BASE="/usr/share/fzf"
        elif [ -d "/usr/local/opt/fzf" ]; then
            export FZF_BASE="/usr/local/opt/fzf"
        fi
        ;;
esac

# Development environment
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

# Project directories
export PROJECTS="$HOME/projects"
export PERSONAL="$HOME/personal"
export WORK="$HOME/work"
export DOTFILES="$HOME/.dotfiles"

# Quick directory navigation
cdp() { cd "$PROJECTS/$1" }
cdw() { cd "$WORK/$1" }
cdpr() { cd "$PERSONAL/$1" }
cdd() { cd "$DOTFILES/$1" }

# Git commit with message
gitcm() { git commit -m "$1" }

# Directory creation and navigation
mkcd() { mkdir -p "$1" && cd "$1" }

# Quick development environment setup
devenv() {
    SESSION_NAME=${1:-dev}
    tmux new-session -d -s "$SESSION_NAME"
    tmux rename-window -t "$SESSION_NAME:1" 'editor'
    tmux new-window -t "$SESSION_NAME:2" -n 'shell'
    tmux new-window -t "$SESSION_NAME:3" -n 'tools'
    tmux select-window -t "$SESSION_NAME:1"
    tmux attach-session -t "$SESSION_NAME"
}

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Directory options
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

# Completion configuration
setopt COMPLETE_ALIASES
setopt GLOB_COMPLETE
setopt MENU_COMPLETE
setopt NO_NOMATCH

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --style=numbers --color=always {}'"

# Fun terminal commands
alias sysinfo='fastfetch --load-config ~/.config/fastfetch/minimal.jsonc'
alias sysfull='fastfetch --load-config ~/.config/fastfetch/config.jsonc'
alias doggo='[[ -f ~/.dotfiles/ascii/dog.txt ]] && cat ~/.dotfiles/ascii/dog.txt | lolcat'
alias birb='[[ -f ~/.dotfiles/ascii/pigeon.txt ]] && cat ~/.dotfiles/ascii/pigeon.txt | lolcat'
alias matrix='cmatrix -C cyan'
alias pipes='pipes.sh -t 1 -c cyan'
alias welcome='source ~/.dotfiles/scripts/welcome.sh'
alias say='figlet -f small | lolcat -F 0.5'

# Load any machine-specific configurations
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Load welcome script on interactive non-tmux shells
if [[ $- == *i* ]] && [ -z "$TMUX" ]; then
  [[ -f "$HOME/.dotfiles/scripts/welcome.sh" ]] && source "$HOME/.dotfiles/scripts/welcome.sh"
fi

# Initialize Starship prompt (must be last)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi
