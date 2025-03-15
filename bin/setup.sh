#!/bin/bash
echo "🚀 Setting up Brightside CLI..."

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
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "✅ Homebrew is already installed."
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
    sudo apt update
    sudo apt install -y fonts-powerline fonts-hack-ttf
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

# Ensure Zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "⚠️ Zsh is not installed! Installing now..."
    $INSTALL_CMD zsh
else
    echo "✅ Zsh is already installed."
fi

# Ensure Git is installed
if ! command -v git &> /dev/null; then
    echo "⚠️ Git is not installed! Installing now..."
    $INSTALL_CMD git
else
    echo "✅ Git is already installed."
fi

# Ensure GitHub CLI (`gh`) is installed
if ! command -v gh &> /dev/null; then
    echo "🔧 Installing GitHub CLI..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
    else
        sudo apt update && sudo apt install -y gh
    fi
else
    echo "✅ GitHub CLI (gh) is already installed."
fi

# Configure Git User if not set
GIT_NAME=$(git config --global user.name)
GIT_EMAIL=$(git config --global user.email)

if [[ -z "$GIT_NAME" || -z "$GIT_EMAIL" ]]; then
    echo "🛠️ Configuring Git User..."
    read -p "Enter your Git user name: " GIT_NAME
    git config --global user.name "$GIT_NAME"

    read -p "Enter your Git email: " GIT_EMAIL
    git config --global user.email "$GIT_EMAIL"
    
    echo "✅ Git user configured: $GIT_NAME <$GIT_EMAIL>"
else
    echo "✅ Git user is already set: $GIT_NAME <$GIT_EMAIL>"
fi

# Ensure scripts in bin/ are executable
echo "🔧 Setting executable permissions for scripts..."
chmod +x "$BRIGHTSIDE_ROOT/bin/"*

# Add bin directory to PATH (Only if it's not already in ~/.zshrc or ~/.bashrc)
if ! grep -q "$BRIGHTSIDE_ROOT/bin" "$HOME/.zshrc"; then
    echo "🔗 Adding Brightside CLI to PATH..."
    echo "export BRIGHTSIDE_ROOT=\"$BRIGHTSIDE_ROOT\"" >> "$HOME/.zshrc"
    echo 'export PATH="$BRIGHTSIDE_ROOT/bin:$PATH"' >> "$HOME/.zshrc"
    echo 'export PATH="$BRIGHTSIDE_ROOT/bin:$PATH"' >> "$HOME/.bashrc"
    echo "✅ PATH updated!"
else
    echo "✅ Brightside CLI is already in PATH."
fi

# Backup .zshrc (Only if it hasn't been backed up before)
if [ -f "$HOME/.zshrc" ] && [ ! -f "$HOME/.zshrc.backup" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
    echo "📦 Backed up existing .zshrc to .zshrc.backup"
fi

# Symlink new .zshrc
ln -sf "$BRIGHTSIDE_ROOT/config/.zshrc" "$HOME/.zshrc"
echo "🔗 Linked new .zshrc file."

# Set Zsh as default shell (only if not already set)
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    echo "🛠️ Changing default shell to Zsh..."
    chsh -s $(which zsh)
else
    echo "✅ Zsh is already the default shell."
fi

# Install Python dependencies (use the correct Python version)
echo "🐍 Installing Python dependencies..."
python3 -m pip install --upgrade pip
python3 -m pip install yt-dlp whisper

# Mark installation as complete
touch "$HOME/.brightside_installed"

echo "🎉 Setup complete! Restart your terminal or run 'exec zsh' to apply changes."

echo "💡 **IMPORTANT:** To enable Powerlevel10k, open your terminal settings and set your font to 'Hack Nerd Font' or 'MesloLGS NF'."