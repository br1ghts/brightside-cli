# 🚀 Brightside CLI

Brightside CLI is a powerful command-line tool for automating downloads, subtitles, and more.  
Built with **Python & Bash**, it simplifies **YouTube downloads, subtitle generation, and system setup**.

## 🎯 Features
- **Download YouTube videos** as **MP3 or MP4** (`ytmp3`, `ytmp4`)
- **Generate subtitles** from audio using Whisper AI (`whisper-sub`)
- **Easy setup** with `brightside setup`
- **Custom download paths** for videos
- **Fully scriptable** with automation-friendly CLI

---

## 📥 Installation

### **Step 1: Clone the Repository**
```bash
git clone https://github.com/br1ghts/brightside-cli.git ~/brightside-cli
cd ~/brightside-cli
```

### **Step 2: Run Setup**
```bash
bash bin/setup.sh
```
This installs all dependencies (**Zsh, Python, yt-dlp, Whisper AI**).

### **Step 3: Restart Your Terminal**
```bash
exec zsh
```

---

## 🎛️ Usage

After installation, you can run Brightside CLI commands from anywhere.

### **Download YouTube Video as MP3**
```bash 
brightside ytmp3 "https://youtu.be/video_id"
```
➡ Saves the MP3 to `~/Music/`.

You can change download locations by passing a custom folder:
```bash
brightside ytmp3 "https://youtu.be/video_id" ~/Downloads
```

### **Download YouTube Video as MP4**
```bash
brightside ytmp4 "https://youtu.be/video_id"
```
➡ Saves the MP4 to `~/Videos/`.

### **Generate Subtitles from Audio**
```bash
brightside whisper-sub myaudio.wav
```
➡ Generates an **SRT subtitle file**.

### **Show Available Commands**
```bash
brightside --help
```

### **Check Brightside CLI Version**
```bash
brightside --version
```

---

## 🔄 Updating Brightside CLI

To update to the latest version:
```bash
cd ~/brightside-cli
git pull
bash bin/setup.sh
```

---

## 🤝 Contributing

Want to improve Brightside CLI? Fork the repo, make changes, and submit a PR!

### **Guidelines for Contributions**
1. Open an issue if you want to suggest a new feature or bug fix.
2. Fork the repository and create a feature branch.
3. Submit a pull request with a clear description of your changes.

---

## 📜 License

This project is **open-source** under the **MIT License**.

---

## 📅 Future Features (Expansion Plan)

Here are some planned improvements for Brightside CLI v2.0:

- **Convert command** – Convert MP3 to WAV or vice versa.
- **Compress command** – Compress MP4 videos automatically.
- **Implement logging** – Save all CLI actions to `~/.brightside.log` file.
- **AI-based Audio Cleaning** – Use Whisper AI for noise reduction.