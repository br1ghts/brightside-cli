# Brightside CLI Documentation

## Overview

Brightside CLI is a collection of personal tools and scripts designed to enhance your command-line workflow. It is designed to be portable and easy to set up on any machine.

## Installation

### Prerequisites

- A Unix-based operating system (macOS or Linux)
- `git` installed
- `zsh` installed (if using Zsh features)

### Cloning the Repository

```bash
cd ~
git clone https://github.com/yourusername/brightside-cli.git
```

### Running Setup Script

After cloning, run the setup script to configure everything:

```bash
cd brightside-cli
bin/setup.sh
```

This will:

- Automatically detect the installation directory
- Set executable permissions for scripts
- Add the `bin/` directory to your system `PATH`
- Backup and link your `.zshrc` configuration

After running the setup script, restart your terminal or run:

```bash
source ~/.zshrc
```

## Folder Structure

```
brightside-cli/
├── bin/                  # Executable CLI scripts
│   ├── whisper-sub       # Whisper subtitles tool
│   ├── ytmp3             # YouTube MP3 downloader
│   ├── ytmp4             # YouTube MP4 downloader
│   ├── zsh.sh            # Zsh plugin setup
│   ├── setup.sh          # Setup script
├── config/               # Configuration files
│   ├── .zshrc            # Custom Zsh configuration
├── docs/                 # Documentation
│   ├── usage.md          # Usage instructions
├── tests/                # Test scripts
├── README.md             # Project overview
├── LICENSE               # License information
└── .gitignore            # Ignored files
```

## Usage

Once installed, you can run the tools from anywhere in the terminal.

### Example Commands

- **Convert YouTube Video to MP3:**

  ```bash
  ytmp3 <video_url>
  ```

- **Download YouTube Video as MP4:**

  ```bash
  ytmp4 <video_url>
  ```

- **Generate Subtitles with Whisper:**

  ```bash
  whisper-sub <audio_file>
  ```

## Customization

You can modify your `.zshrc` configuration at:

```bash
$BRIGHTSIDE_ROOT/config/.zshrc
```

Make changes and reload:

```bash
source ~/.zshrc
```

## Updating

To update to the latest version:

```bash
cd $BRIGHTSIDE_ROOT
git pull
bin/setup.sh
```

## Contributing

If you have improvements or new scripts, feel free to contribute!

## License

This project is licensed under the MIT License.

---


