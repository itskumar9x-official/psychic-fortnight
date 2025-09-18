# Dockerfile - simple ffmpeg container for Render
FROM ubuntu:22.04


ENV DEBIAN_FRONTEND=noninteractive


# install needed packages
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
ffmpeg \
curl \
ca-certificates \
wget \
bash \
&& rm -rf /var/lib/apt/lists/*


# Create app dir
WORKDIR /app


# Copy start script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh


# By default assume media files are present in repo. If you provide URLs via env vars, start.sh will download them.


# Use a non-root user (optional but good practice)
RUN useradd -m appuser || true
USER appuser


# Start the streaming script
CMD ["/app/start.sh"]
