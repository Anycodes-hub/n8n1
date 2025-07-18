# Base: Node.js for n8n + Python + FFmpeg + TTS
FROM node:20.19-bullseye

# Set environment variables
ENV N8N_VERSION=1.100.1
ENV NODE_ENV=production
ENV PIP_NO_CACHE_DIR=1
ENV PYTHONUNBUFFERED=1

# Install system tools, Python, FFmpeg, espeak, fonts, etc.
RUN apt-get update && apt-get install -y \
  ffmpeg \
  build-essential \
  python3 \
  python3-pip \
  python3-venv \
  espeak \
  git \
  curl \
  wget \
  libsndfile1 \
  libglib2.0-0 \
  libsm6 \
  libxext6 \
  libxrender1 \
  imagemagick \
  ttf-dejavu \
  fonts-dejavu \
  && apt-get clean

# Set working directory
WORKDIR /app

# Install n8n globally
RUN npm install -g n8n@$N8N_VERSION

# Clone and install Coqui TTS
RUN git clone https://github.com/coqui-ai/TTS.git /app/TTS
WORKDIR /app/TTS
RUN pip install -r requirements.txt && pip install .

# Install subtitle and formatting libraries
RUN pip install srt textwrap3 numpy scipy

# [Optional] Add CLI support for AI image generation (like Stable Diffusion)
# You can add your CLI tool here later if needed.

# Return to app directory
WORKDIR /app

# Expose default n8n port
EXPOSE 5678

# Run n8n
CMD ["n8n"]
