#!/bin/bash

# Brightside CLI Banner
cat << "EOF"
██████╗ ██████╗ ██╗ ██████╗ ██╗  ██╗████████╗███████╗██╗██████╗ ███████╗
██╔══██╗██╔══██╗██║██╔════╝ ██║  ██║╚══██╔══╝██╔════╝██║██╔══██╗██╔════╝
██████╔╝██████╔╝██║██║  ███╗███████║   ██║   ███████╗██║██║  ██║█████╗  
██╔══██╗██╔══██╗██║██║   ██║██╔══██║   ██║   ╚════██║██║██║  ██║██╔══╝  
██████╔╝██║  ██║██║╚██████╔╝██║  ██║   ██║   ███████║██║██████╔╝███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝╚═════╝ ╚══════╝
EOF

# Detect Brightside CLI root directory
BRIGHTSIDE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "📂 Brightside CLI root detected at: $BRIGHTSIDE_ROOT"

# Prevent duplicate setup
if [ -f "$HOME/.brightside_installed" ]; then
    echo "✅ Brightside CLI is already installed. Run 'brightside --help' to get started."
    exit 0
fi

# Detect OS (Linux/macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍏 macOS detected. Checking dependencies..."
    INSTALL_CMD="brew install"
    ZSH_PATH="/bin/zsh"

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
    echo "🍺 Homebrew not found. Installing..."

    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Determine the correct Homebrew path
    if [[ "$OSTYPE" == "darwin"* ]]; then
        BREW_PATH="/opt/homebrew/bin/brew"
    else
        BREW_PATH="/home/linuxbrew/.linuxbrew/bin/brew"
    fi

    # Ensure Homebrew is in PATH
    if [[ -f "$BREW_PATH" ]]; then
        echo "✅ Homebrew installed at $BREW_PATH"
        echo "eval \"\$($BREW_PATH shellenv)\"" >> "$HOME/.zshrc"
        eval "$($BREW_PATH shellenv)"
    else
        echo "❌ Homebrew installation failed."
        exit 1
    fi
else
    echo "✅ Homebrew is already installed."
fi

# Ensure Homebrew is in PATH for both macOS and Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
else
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

# Ensure brew shellenv is sourced
if ! grep -q "brew shellenv" "$HOME/.zshrc"; then
    echo "eval \"\$($HOMEBREW_PREFIX/bin/brew shellenv)\"" >> "$HOME/.zshrc"
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

# **🔥 Install Dependencies (Correct for macOS & Linux)**
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install git zsh pipx
    brew install --cask font-hack-nerd-font
else
    brew install git zsh pipx
fi

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Linux detected. Checking dependencies..."
    INSTALL_CMD="sudo apt install -y"
    ZSH_PATH="/usr/bin/zsh"

    sudo apt update && sudo apt install -y git zsh curl wget fonts-powerline pipx
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

# Ensure Zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "⚠️ Installing Zsh..."
    $INSTALL_CMD zsh
fi

# Ensure Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "⚡ Installing Oh My Zsh (non-interactive)..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Ensure Powerlevel10k is installed
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "🎨 Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Ensure Zsh plugins are installed
PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
fi
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
fi

# Ensure Python dependencies are installed using pipx
if ! command -v pipx &> /dev/null; then
    echo "🔧 Installing pipx..."
    $INSTALL_CMD pipx
    pipx ensurepath
fi

pipx install yt-dlp whisper feedparser

# Link new .zshrc
if [ -f "$BRIGHTSIDE_ROOT/config/.zshrc" ]; then
    echo "🔗 Linking new .zshrc file..."
    ln -sf "$BRIGHTSIDE_ROOT/config/.zshrc" "$HOME/.zshrc"
fi

# Ensure Brightside CLI is in PATH
if ! grep -q "$BRIGHTSIDE_ROOT/bin" "$HOME/.zshrc"; then
    echo "export BRIGHTSIDE_ROOT=\"$BRIGHTSIDE_ROOT\"" >> "$HOME/.zshrc"
    echo "export PATH=\"$BRIGHTSIDE_ROOT/bin:\$PATH\"" >> "$HOME/.zshrc"
    echo "✅ PATH updated!"
fi

# Set Zsh as the default shell (ONLY if it isn't already set)
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    echo "🛠️ Changing default shell to Zsh..."
    chsh -s $(which zsh)
    echo "⚡ Restart your terminal or run 'exec zsh' to apply changes."
fi

# Mark installation as complete
touch "$HOME/.brightside_installed"

echo "🎉 Setup complete! Restart your terminal or run 'exec zsh' to apply changes."
echo "💡 **IMPORTANT:** To enable Powerlevel10k, open your terminal settings and set your font to 'Hack Nerd Font' or 'MesloLGS NF'."
