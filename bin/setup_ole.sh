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
# if [ -f "$HOME/.brightside_installed" ]; then
#     echo "✅ Brightside CLI is already installed. Run 'brightside --help' to get started."
#     exit 0
# fi

# Detect OS (Linux, macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍏 macOS detected. Checking dependencies..."
    INSTALL_CMD="brew install"
    ZSH_PATH="/bin/zsh"

    # Check if Homebrew is installed, install if missing
    if ! command -v brew &> /dev/null; then
        echo "🍺 Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Ensure Homebrew is added to PATH properly after install
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
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

# Ensure Oh My Zsh is installed before setting themes/plugins
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "⚡ Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "✅ Oh My Zsh is already installed."
fi

# Install Powerlevel10k theme if missing
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "🎨 Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
else
    echo "✅ Powerlevel10k is already installed."
fi

# Install plugins if missing
PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    echo "🛠️ Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
fi
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    echo "🛠️ Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
fi

# Ensure Git is installed
if ! command -v git &> /dev/null; then
    echo "⚠️ Git is not installed! Installing now..."
    $INSTALL_CMD git
else
    echo "✅ Git is already installed."
fi

# Ensure scripts in bin/ are executable
echo "🔧 Setting executable permissions for scripts..."
chmod +x "$BRIGHTSIDE_ROOT/bin/"*

# Add bin directory to PATH if not already added
if ! grep -q "$BRIGHTSIDE_ROOT/bin" "$HOME/.zshrc"; then
    echo "🔗 Adding Brightside CLI to PATH..."
    echo "export BRIGHTSIDE_ROOT=\"$BRIGHTSIDE_ROOT\"" >> "$HOME/.zshrc"
    echo 'export PATH="$BRIGHTSIDE_ROOT/bin:$PATH"' >> "$HOME/.zshrc"
    echo "✅ PATH updated!"
else
    echo "✅ Brightside CLI is already in PATH."
fi

# Backup .zshrc (only once)
if [ -f "$HOME/.zshrc" ] && [ ! -f "$HOME/.zshrc.backup" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
    echo "📦 Backed up existing .zshrc to .zshrc.backup"
fi

# Symlink new .zshrc if it exists
if [ -f "$BRIGHTSIDE_ROOT/config/.zshrc" ]; then
    ln -sf "$BRIGHTSIDE_ROOT/config/.zshrc" "$HOME/.zshrc"
    echo "🔗 Linked new .zshrc file."
fi

# Set Zsh as default shell
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    echo "🛠️ Changing default shell to Zsh..."
    chsh -s $(which zsh)
else
    echo "✅ Zsh is already the default shell."
fi

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
python3 -m pip3 install --upgrade pip
python3 -m pip3 install yt-dlp whisper

# Mark installation as complete
touch "$HOME/.brightside_installed"

source ~/.zshrc

echo "🎉 Setup complete! Restart your terminal or run 'exec zsh' to apply changes."
echo "💡 **IMPORTANT:** To enable Powerlevel10k, set your font to 'Hack Nerd Font' or 'MesloLGS NF'."
