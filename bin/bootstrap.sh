#!/bin/bash

echo "🚀 Starting Brightside CLI Bootstrap..."

# Automatically detect root directory
BRIGHTSIDE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="$BRIGHTSIDE_ROOT/setup.log"

# Run the main setup script with logging
echo "🛠️ Running setup.sh..."
bash "$BRIGHTSIDE_ROOT/bin/setup.sh" | tee "$LOG_FILE"

# If setup fails, print an error and exit
if [ $? -ne 0 ]; then
    echo "❌ Setup failed! Check the log at $LOG_FILE"
    exit 1
fi

# Run post-setup to finalize everything
echo "🔄 Running post-setup..."
bash "$BRIGHTSIDE_ROOT/bin/post-setup.sh"

echo "🎉 Brightside CLI setup complete!"
