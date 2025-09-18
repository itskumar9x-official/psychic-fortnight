#!/bin/bash
set -e

STREAM_KEY="$YOUTUBE_KEY"

while true
do
    ffmpeg -re \
      -stream_loop -1 -i mainvideonosound.mp4 \
      -stream_loop -1 -i song1.mp3 \
      -c:v libx264 -b:v 3000k -maxrate 3000k -bufsize 6000k \
      -s 1280x720 -preset veryfast -pix_fmt yuv420p \
      -c:a aac -b:a 128k -ar 44100 -ac 2 \
      -g 60 -keyint_min 48 \
      -force_key_frames "expr:gte(t,n_forced*4)" \
      -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"

    echo "FFmpeg crashed. Restarting in 10 seconds..."
    sleep 10
done
