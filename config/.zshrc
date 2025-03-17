function badass_welcome() {
    # Only run if this is an interactive shell (so it doesn’t run in scripts)
    [[ $- == *i* ]] || return

    emulate -L zsh  # Ensure compatibility mode

    # Add a slight delay for dramatic effect
    sleep 0.1  

    # Cyberpunk Glitch Effect - Random Symbols Scroll
    local symbols=("█▒░" "▓█░" "░▒▓" "███" "▓▓▒" "▒░▓")
    for i in {1..10}; do
        print -Pn "%F{green}${symbols[RANDOM % ${#symbols[@]}]}%F{black} Initializing...\r"
        sleep 0.1
    done
    print ""  # Newline after animation

    # Boot Animation
    local chars=("■" "■ ■" "■ ■ ■" "■ ■ ■ ■" "■ ■ ■ ■ ■")
    for i in {1..5}; do
        print -Pn "%F{red}${chars[i]} %F{black}Booting up...\r"
        sleep 0.2
    done
    print ""  # Newline after animation

    # Cyberpunk System Log
    sleep 0.2
    print -P "%F{cyan}[LOG] %F{green}Neural uplink established...%f"
    sleep 0.2
    print -P "%F{cyan}[LOG] %F{yellow}Decrypting access protocols...%f"
    sleep 0.2
    print -P "%F{cyan}[LOG] %F{magenta}Environment loaded successfully.%f"
    sleep 0.2

    # Final Cyberpunk Welcome Message
    print -P '%F{red}💀 SYSTEM ONLINE...%f'
    sleep 0.1
    print -P '%F{blue}🕶️ Welcome back to the Brightside, MrBrightside.%f'
}

# ⚡️ Powerlevel10k Instant Prompt for blazing speed
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme: Powerlevel10k for a crisp, customizable prompt
ZSH_THEME="powerlevel10k/powerlevel10k"

# Essential plugins
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# Load Oh-My-Zsh (Required BEFORE customizations)
source $ZSH/oh-my-zsh.sh

# History optimization
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY INC_APPEND_HISTORY
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Enhanced Keybindings
bindkey -e

# Auto-correction & Auto directory navigation
setopt AUTO_CD CORRECT

# Vibrant Aliases
alias c='clear'
alias ls='ls --color=auto'
alias ll='ls -lhF --color=auto'
alias la='ls -A --color=auto'
alias lla='ls -lha --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

# Git aliases for fast productivity
alias gst='git status'
alias gaa='git add .'
alias gcm='git commit -m'
alias gco='git checkout'

# Quick edits and reload
alias zshrc='vim ~/.zshrc'
alias reload='source ~/.zshrc'

#Pipeline Commands
alias pipeline='cd ~/sites/pipeline'
alias pipeline_start='php artisan pipeline:start'
# Better keybindings
bindkey -e

# Enhanced navigation
setopt AUTO_CD
setopt CORRECT

# Advanced completion setup
autoload -Uz compinit && compinit
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format '%F{cyan}Completing %d%f'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+l:|=* r:|=*'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Enhanced kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


# Auto-detect the Brightside CLI directory based on the symlink
export BRIGHTSIDE_ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]:-${(%):-%x}}")")"

# Add bin directory to PATH so tools are globally accessible
export PATH="$BRIGHTSIDE_ROOT/bin:$PATH"

# Optional: Set a variable for the config directory
export BRIGHTSIDE_CONFIG="$BRIGHTSIDE_ROOT/config"
export PATH="$HOME/brightside-cli/bin:$PATH"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



export BRIGHTSIDE_ROOT="/Users/rick/sites/brightside-cli"
export PATH="$BRIGHTSIDE_ROOT/bin:$PATH"

# Run this ONLY when starting a new terminal session or sourcing .zshrc
badass_welcome

# Created by `pipx` on 2025-03-16 17:33:34
export PATH="$PATH:/Users/rick/.local/bin"
eval "$(/opt/homebrew/bin/brew shellenv)"
