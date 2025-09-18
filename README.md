# My YouTube Stream (24/7 Loop)

This repository streams a prerecorded video with merged audio to YouTube Live continuously.

## Features
- 24/7 loop streaming
- Merges multiple MP3s into video
- Deployable via Railway (no PC required)
- Works with environment variable for YouTube Stream Key

## Files
- `mainvideonosound.mp4` → Your main video without sound
- `song1.mp3` & `song2.mp3` → Audio files to merge
- `start.sh` → Script to merge and stream video/audio
- `Dockerfile` → Container definition
- `.gitattributes` → For Git LFS (if using large media)

## How to Deploy (Browser Only)
1. Create a GitHub repo and upload this content.
2. Upload your media files via **Git LFS** or **cloud storage with links in start.sh**.
3. Go to [Railway](https://railway.app/) → **New Project** → Deploy from GitHub.
4. Add Environment Variable:
   - Key: `YOUTUBE_KEY`
   - Value: Your YouTube Stream Key (from YouTube Studio → Go Live)
5. Deploy → Container will start → 24/7 streaming begins automatically.

## Notes
- Use Git LFS for files >25MB.
- Public cloud links can be used in `start.sh` to bypass GitHub file size limits.
- Monitor Railway free-tier usage if running 24/7.

