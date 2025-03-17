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

# Automatically detect the Brightside CLI root directory
BRIGHTSIDE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "📂 Brightside CLI root detected at: $BRIGHTSIDE_ROOT"

# Prevent duplicate setup runs
if [ -f "$HOME/.brightside_installed" ]; then
    echo "✅ Brightside CLI is already installed. Run 'brightside --help' to get started."
    exit 0
fi

# Detect OS (Linux, macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍏 macOS detected. Checking dependencies..."
    INSTALL_CMD="brew install"
    ZSH_PATH="/bin/zsh"

    # Check if Homebrew is installed, install if missing
    if ! command -v brew &> /dev/null; then
        echo "🍺 Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "✅ Homebrew is already installed."
    fi

    # Ensure Homebrew is in PATH
    if ! grep -q '/opt/homebrew/bin' "$HOME/.zshrc"; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Install Nerd Fonts (Best for p10k)
    echo "🔡 Installing Hack Nerd Font..."
    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Linux detected. Checking dependencies..."
    INSTALL_CMD="sudo apt install -y"
    ZSH_PATH="/usr/bin/zsh"

    # Install Powerline & Nerd Fonts (Linux alternative)
    echo "🔡 Installing Powerline & Nerd Fonts..."
    sudo apt update && sudo apt install -y fonts-powerline fonts-hack-ttf
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

# Ensure Zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "⚠️ Zsh is not installed! Installing now..."
    $INSTALL_CMD zsh || exit 1
else
    echo "✅ Zsh is already installed."
fi

# Ensure Git is installed
if ! command -v git &> /dev/null; then
    echo "⚠️ Git is not installed! Installing now..."
    $INSTALL_CMD git || exit 1
else
    echo "✅ Git is already installed."
fi

# Ensure GitHub CLI (`gh`) is installed
if ! command -v gh &> /dev/null; then
    echo "🔧 Installing GitHub CLI..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
    else
        sudo apt update && sudo apt install -y gh || exit 1
    fi
else
    echo "✅ GitHub CLI (gh) is already installed."
fi

# Set up pipx for Python dependencies
echo "🐍 Installing Python dependencies with pipx..."
if ! command -v pipx &> /dev/null; then
    echo "🔧 Installing pipx..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install pipx
    else
        sudo apt install -y pipx || exit 1
    fi
    pipx ensurepath
fi

# Force reinstall Python tools to avoid conflicts
pipx install --force yt-dlp whisper feedparser || exit 1

# Add bin directory to PATH (Only if not already in ~/.zshrc)
if ! grep -q "$BRIGHTSIDE_ROOT/bin" "$HOME/.zshrc"; then
    echo "🔗 Adding Brightside CLI to PATH..."
    echo "export BRIGHTSIDE_ROOT=\"$BRIGHTSIDE_ROOT\"" >> "$HOME/.zshrc"
    echo 'export PATH="$BRIGHTSIDE_ROOT/bin:$PATH"' >> "$HOME/.zshrc"
    echo 'export PATH="$BRIGHTSIDE_ROOT/bin:$PATH"' >> "$HOME/.bashrc"
    echo "✅ PATH updated!"
else
    echo "✅ Brightside CLI is already in PATH."
fi

# Set Zsh as default shell (only if not already set)
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    echo "🛠️ Changing default shell to Zsh..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        chsh -s $(which zsh)
    else
        sudo chsh -s $(which zsh) $USER
    fi
else
    echo "✅ Zsh is already the default shell."
fi

# Mark installation as complete
touch "$HOME/.brightside_installed"

echo "🎉 Setup complete! Restart your terminal or run 'exec zsh' to apply changes."
echo "💡 **IMPORTANT:** To enable Powerlevel10k, open your terminal settings and set your font to 'Hack Nerd Font' or 'MesloLGS NF'."

exec zsh  # Auto-start Zsh after setup