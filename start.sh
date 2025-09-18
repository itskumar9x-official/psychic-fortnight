#!/bin/bash
set -e

STREAM_KEY="$YOUTUBE_KEY"

while true
do
    ffmpeg -re \
      -stream_loop -1 -i mainvideonosound.mp4 \
      -stream_loop -1 -i song1.mp3 \
      -c:v libx264 -b:v 3000k -maxrate 3000k -bufsize 6000k -s 1280x720 -preset veryfast \
      -c:a aac -b:a 128k -pix_fmt yuv420p \
      -g 60 -keyint_min 48 \
      -force_key_frames "expr:gte(t,n_forced*4)" \
      -shortest \
      -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
done
