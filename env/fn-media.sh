#!/usr/bin/env bash

#--- Media

# Function to downloads a .mp3 file from YouTube
# Requires youtube-dl
function dlmp3() {
    song="$1"
    youtube-dl -x --extract-audio --audio-format mp3 "ytsearch:${song}"
}
# Function to downloads a .mp4 file from YouTube
function dlmp4() {
    video="$1"
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' "ytsearch:${video}"
}

# Function to echo the current time
### timestamp()
# Just echoes the formatted time
timestamp() {
    date "+%Y-%m-%d_%H:%M:%S"
}
