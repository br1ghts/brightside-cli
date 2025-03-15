# 🎛️ Usage

After installation, you can run Brightside CLI commands from anywhere.

### **Download YouTube Video as MP3**
```bash 
brightside ytmp3 "https://youtu.be/video_id"
```

➡ Saves the MP3 to ~/Music/.

You can change download locations by passing a custom folder:

```bash
brightside ytmp3 "https://youtu.be/video_id" ~/Downloads
```

### **Download YouTube Video as MP4**
```bash
brightside ytmp4 "https://youtu.be/video_id"
```

➡ Saves the MP4 to ~/Videos/.

### **Generate Subtitles from Audio**
```bash
brightside whisper-sub myaudio.wav
```

➡ Generates an SRT subtitle file.

### **Show Available Commands**
```bash
brightside --help
```

### **Check Brightside CLI Version**
```bash
brightside --version
```

## **🔄 Updating Brightside CLI**

To update to the latest version:

```bash
cd ~/brightside-cli
git pull
bash bin/setup.sh
```