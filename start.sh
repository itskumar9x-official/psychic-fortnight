#!/usr/bin/env bash
set -euo pipefail


# Render-friendly 480p streaming script
# Behavior:
# - if VIDEO_URL or AUDIO_URL are set, downloads them to /tmp/media
# - otherwise expects mainvideonosound.mp4 and song1.mp3 in repo
# - loops forever and restarts ffmpeg on failure


STREAM_KEY="${YOUTUBE_KEY:-}"
if [ -z "$STREAM_KEY" ]; then
echo "ERROR: YOUTUBE_KEY environment variable is required"
exit 1
fi


MEDIA_DIR=/tmp/media
mkdir -p "$MEDIA_DIR"


# Helper to download if URL provided
maybe_download() {
local url="$1"; local dest="$2"
if [ -n "${url:-}" ]; then
echo "Downloading $url -> $dest"
wget -q -O "$dest" "$url" || (echo "Failed to download $url" && exit 1)
fi
}


# If user set env vars VIDEO_URL / AUDIO_URL, use them
maybe_download "${VIDEO_URL:-}" "$MEDIA_DIR/mainvideonosound.mp4"
maybe_download "${AUDIO_URL:-}" "$MEDIA_DIR/song1.mp3"


# If files were not downloaded, fall back to repo files
VIDEO_PATH="$MEDIA_DIR/mainvideonosound.mp4"
AUDIO_PATH="$MEDIA_DIR/song1.mp3"


if [ ! -f "$VIDEO_PATH" ]; then
if [ -f ./mainvideonosound.mp4 ]; then
VIDEO_PATH=./mainvideonosound.mp4
else
echo "ERROR: video file not found. Provide mainvideonosound.mp4 in repo or set VIDEO_URL"
exit 1
fi
fi


if [ ! -f "$AUDIO_PATH" ]; then
if [ -f ./song1.mp3 ]; then
AUDIO_PATH=./song1.mp3
else
echo "ERROR: audio file not found. Provide song1.mp3 in repo or set AUDIO_URL"
exit 1
fi
fi


# Loop and stream
while true; do
echo "Starting ffmpeg -> YouTube (480p, 128k audio)"
ffmpeg -re \
-stream_loop -1 -i "$VIDEO_PATH" \
-stream_loop -1 -i "$AUDIO_PATH" \
-c:v libx264 -preset veryfast -s 854x480 -b:v 1500k -maxrate 1500k -bufsize 3000k -pix_fmt yuv420p \
-g 60 -keyint_min 48 -force_key_frames "expr:gte(t,n_forced*4)" \
-c:a aac -b:a 128k -ar 44100 -ac 2 \
done
