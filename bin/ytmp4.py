#!/usr/bin/env python3
import sys
import os
import yt_dlp

def download_mp4(url):
    ydl_opts = {
        'format': 'bestvideo+bestaudio',
        'merge_output_format': 'mp4',
        'outtmpl': '~/Videos/%(title)s.%(ext)s'
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        ydl.download([url])

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("❌ Usage: ytmp4 <YouTube URL>")
        sys.exit(1)

    url = sys.argv[1]
    download_mp4(url)