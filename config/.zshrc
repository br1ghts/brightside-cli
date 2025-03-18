# Function: Cyberpunk Welcome
function badass_welcome() {
    # Only run in an interactive shell
    [[ $- == *i* ]] || return

    emulate -L zsh  # Ensure compatibility mode

    # Cyberpunk Boot Animation
    local symbols=("█▒░" "▓█░" "░▒▓" "███" "▓▓▒" "▒░▓")
    for i in {1..10}; do
        print -Pn "%F{green}${symbols[RANDOM % ${#symbols[@]}]}%F{black} Initializing...\r"
        sleep 0.1
    done
    print ""  # Newline after animation

    # System Logs
    sleep 0.2
    print -P "%F{cyan}[LOG] %F{green}Neural uplink established...%f"
    sleep 0.2
    print -P "%F{cyan}[LOG] %F{yellow}Decrypting access protocols...%f"
    sleep 0.2
    print -P "%F{cyan}[LOG] %F{magenta}Environment loaded successfully.%f"
    sleep 0.2

    # Final Welcome Message
    print -P '%F{red}💀 SYSTEM ONLINE...%f'
    sleep 0.1
    print -P '%F{blue}🕶️ Welcome back to the Brightside, MrBrightside.%f'
}

# Powerlevel10k Instant Prompt
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh Setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# Source Oh My Zsh (Only If It Exists)
if [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
    source "$HOME/.oh-my-zsh/oh-my-zsh.sh"
else
    echo "⚠️ Warning: Oh My Zsh is missing!"
fi

# History Optimization
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY INC_APPEND_HISTORY
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Enhanced Keybindings
bindkey -e

# Auto-correction & Auto directory navigation
setopt AUTO_CD CORRECT

# Git Aliases
alias gst='git status'
alias gaa='git add .'
alias gcm='git commit -m'
alias gco='git checkout'

alias c='clear'

# Quick Edits and Reload
alias zshrc='vim ~/.zshrc'
alias reload='source ~/.zshrc'

# Advanced Completion Setup
autoload -Uz compinit && compinit
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format '%F{cyan}Completing %d%f'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+l:|=* r:|=*'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Homebrew (Mac & Linux)
if command -v brew &> /dev/null; then
    eval "$(brew shellenv)"
else
    echo "⚠️ Warning: Homebrew is not installed! Install it with:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
fi


# Brightside CLI Path Setup
export BRIGHTSIDE_ROOT="$HOME/brightside-cli"
export PATH="$BRIGHTSIDE_ROOT/bin:$PATH"

# Run Welcome Message Only in New Terminal Sessions
if [[ -n "$PS1" && -z "$WELCOME_RAN" ]]; then
    export WELCOME_RAN=1
    badass_welcome
fi

# Source Powerlevel10k Config (if exists)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
source $HOME/.oh-my-zsh/oh-my-zsh.sh

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export BRIGHTSIDE_ROOT="$HOME/brightside-cli"
export PATH="$BRIGHTSIDE_ROOT/bin:$PATH"

