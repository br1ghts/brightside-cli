#!/usr/bin/env python3
import whisper
import ffmpeg
import sys
import os

# Ensure user provides an input file
if len(sys.argv) < 2:
    print("Usage: whisper_subs.py <video/audio file>")
    sys.exit(1)

input_file = sys.argv[1]

# Extract audio if input is a video
audio_file = "temp_audio.wav"
if input_file.endswith((".mp4", ".mkv", ".mov", ".avi")):
    print("Extracting audio...")
    ffmpeg.input(input_file).output(audio_file, format="wav").run(overwrite_output=True)
else:
    audio_file = input_file  # Already an audio file

# Load Whisper model
print("Transcribing...")
model = whisper.load_model("small")  # Change to "medium" or "large" for better accuracy
result = model.transcribe(audio_file)

# Save subtitles in SRT format
srt_file = os.path.splitext(input_file)[0] + ".srt"
with open(srt_file, "w") as f:
    for i, segment in enumerate(result["segments"]):
        start = segment["start"]
        end = segment["end"]
        text = segment["text"]

        # Convert time to SRT format (hh:mm:ss,ms)
        def format_time(seconds):
            millis = int((seconds % 1) * 1000)
            hours = int(seconds // 3600)
            minutes = int((seconds % 3600) // 60)
            seconds = int(seconds % 60)
            return f"{hours:02}:{minutes:02}:{seconds:02},{millis:03}"

        f.write(f"{i+1}\n{format_time(start)} --> {format_time(end)}\n{text}\n\n")

print(f"Subtitles saved as {srt_file}")

# Clean up temporary audio file
if input_file.endswith((".mp4", ".mkv", ".mov", ".avi")):
    os.remove(audio_file)
