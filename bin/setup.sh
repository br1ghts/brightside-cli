#!/bin/bash

# Brightside CLI Banner
cat << "EOF"
██████╗ ██████╗ ██╗ ██████╗ ██╗  ██╗████████╗███████╗██╗██████╗ ███████╗
██╔══██╗██╔══██╗██║██╔════╝ ██║  ██║╚══██╔══╝██╔════╝██║██╔══██╗██╔════╝
██████╔╝██████╔╝██║██║  ███╗███████║   ██║   ███████╗██║██║  ██║█████╗  
██╔══██╗██╔══██╗██║██║   ██║██╔══██║   ██║   ╚════██║██║██║  ██║██╔══╝  
██████╔╝██║  ██║██║╚██████╔╝██║  ██║   ██║   ███████║██║██████╔╝███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚══════╝╚═╝╚═════╝ ╚══════╝
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

    # Ensure Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "🍺 Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "✅ Homebrew is already installed."
    fi

    # Ensure Homebrew is in PATH
    if [[ ! -f "$HOME/.zshrc" ]]; then
        touch "$HOME/.zshrc"
    fi

    if ! grep -q '/opt/homebrew/bin' "$HOME/.zshrc"; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Install Nerd Fonts (Best for p10k)
    echo "🔡 Installing Hack Nerd Font..."
    brew install --cask font-hack-nerd-font || echo "⚠️ Nerd Font already installed."

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

# Ensure Powerlevel10k is Installed
P10K_PATH="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
if [[ ! -d "$P10K_PATH" ]]; then
    echo "💎 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_PATH"
    echo "✅ Powerlevel10k installed successfully!"
else
    echo "✅ Powerlevel10k is already installed."
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

# Ensure Python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "🐍 Python3 not found! Installing..."
    $INSTALL_CMD python3 || exit 1
else
    echo "✅ Python3 is already installed."
fi

# Ensure pip is installed
if ! command -v pip &> /dev/null && ! command -v pip3 &> /dev/null; then
    echo "⚠️ pip is missing! Installing..."
    python3 -m ensurepip --default-pip || exit 1
fi

# Ensure pipx is installed
echo "🐍 Installing Python dependencies with pipx..."
if ! command -v pipx &> /dev/null; then
    echo "🔧 Installing pipx..."
    $INSTALL_CMD pipx || exit 1
    pipx ensurepath
fi

# Ensure Python Virtual Environment is Set Up (Fixes PEP 668)
PYTHON_VENV_PATH="$HOME/.brightside_venv"

# Check if Virtual Environment Exists, If Not, Create It
if [[ ! -d "$PYTHON_VENV_PATH" ]]; then
    echo "🛠️ Creating Python virtual environment at $PYTHON_VENV_PATH"
    python3 -m venv "$PYTHON_VENV_PATH" || exit 1
fi

# Activate the Virtual Environment
echo "🔗 Activating Python virtual environment..."
source "$PYTHON_VENV_PATH/bin/activate"

# Upgrade pip inside the Virtual Environment
echo "⬆️ Upgrading pip inside the virtual environment..."
"$PYTHON_VENV_PATH/bin/python3" -m pip install --upgrade pip || exit 1

# Install Python libraries inside the Virtual Environment
echo "📦 Installing Python dependencies inside the virtual environment..."
"$PYTHON_VENV_PATH/bin/python3" -m pip install --upgrade feedparser || exit 1

# Ensure Brightside's Custom .zshrc is Used
BRIGHTSIDE_ZSHRC="$BRIGHTSIDE_ROOT/config/.zshrc"
DEFAULT_ZSHRC="$HOME/.zshrc"

# Ensure Powerlevel10k is set as the theme in .zshrc
if ! grep -q "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" "$HOME/.zshrc"; then
    echo "⚡ Setting Powerlevel10k as default Zsh theme..."
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
    echo "✅ Powerlevel10k theme set!"
fi

if [[ -f "$BRIGHTSIDE_ZSHRC" ]]; then
    echo "🔗 Linking Brightside custom .zshrc to $HOME/.zshrc"

    # Backup existing .zshrc if it exists
    if [[ -f "$DEFAULT_ZSHRC" && ! -L "$DEFAULT_ZSHRC" ]]; then
        echo "📂 Backing up existing .zshrc to $HOME/.zshrc.bak"
        mv "$DEFAULT_ZSHRC" "$HOME/.zshrc.bak"
    fi

    # Symlink Brightside's .zshrc
    ln -sf "$BRIGHTSIDE_ZSHRC" "$DEFAULT_ZSHRC"
    echo "✅ Brightside custom .zshrc is now linked!"
else
    echo "⚠️ Brightside .zshrc not found in $BRIGHTSIDE_ZSHRC, using default."
fi

# Set Zsh as default shell (only if not already set)
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    echo "🛠️ Changing default shell to Zsh..."
    chsh -s /bin/zsh
else
    echo "✅ Zsh is already the default shell."
fi

# Mark installation as complete
touch "$HOME/.brightside_installed"

echo "🎉 Setup complete! Restart your terminal or run 'exec zsh' to apply changes."
exec zsh