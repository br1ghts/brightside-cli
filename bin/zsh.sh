#!/bin/bash

# Detect OS (macOS or Linux/WSL)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 macOS detected! Setting you up..."
    # Install via Homebrew on macOS
    brew install zsh git wget curl
    brew install font-hack-nerd-font
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Linux detected!"
    sudo apt update && sudo apt install -y zsh git curl wget fonts-powerline
else
    echo "⚠️ Unsupported OS: $OSTYPE"
    exit 1
fi

# Install Oh My Zsh (common to all OS)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Set Zsh as default shell
chsh -s $(which zsh)

# Link .zshrc from repo (assuming it's stored in this repo folder)
cp ./zshrc ~/.zshrc

# Source the new configuration
source ~/.zshrc

echo "✅ Setup complete, choom! Let's hack reality ⚡️"
