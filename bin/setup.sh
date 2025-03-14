#!/bin/bash
echo "Setting up Brightside CLI..."

# Automatically detect the Brightside CLI root directory
BRIGHTSIDE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Brightside CLI root detected at: $BRIGHTSIDE_ROOT"

# Ensure scripts in bin/ are executable
chmod +x "$BRIGHTSIDE_ROOT/bin/"*

# Add bin directory to PATH if not already added
if ! grep -q "$BRIGHTSIDE_ROOT/bin" "$HOME/.zshrc"; then
    echo "export BRIGHTSIDE_ROOT=\"$BRIGHTSIDE_ROOT\"" >> "$HOME/.zshrc"
    echo 'export PATH="$BRIGHTSIDE_ROOT/bin:$PATH"' >> "$HOME/.zshrc"
    echo "Added Brightside CLI to PATH."
fi

# Symlink .zshrc (backup existing first)
if [ -f "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
    echo "Backed up existing .zshrc to .zshrc.backup"
fi
ln -sf "$BRIGHTSIDE_ROOT/config/.zshrc" "$HOME/.zshrc"
echo "Linked .zshrc file."

echo "Setup complete! Restart your terminal or run 'source ~/.zshrc'"