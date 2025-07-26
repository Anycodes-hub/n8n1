FROM node:20.19-bullseye

# Environment
ENV NODE_ENV=production
ENV PIP_NO_CACHE_DIR=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies + build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    git \
    build-essential \
    yasm \
    pkg-config \
    libfreetype6-dev \
    libfontconfig1 \
    libfribidi-dev \
    libass-dev \
    libssl-dev \
    libvorbis-dev \
    libx264-dev \
    libx265-dev \
    libvpx-dev \
    libopus-dev \
    libfdk-aac-dev \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    espeak \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    imagemagick \
    fonts-dejavu-core \
    fonts-dejavu-extra \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Build FFmpeg 7.0.2 with drawtext and other essential codecs
RUN mkdir -p /build && cd /build && \
    wget https://ffmpeg.org/releases/ffmpeg-7.0.2.tar.xz && \
    tar -xf ffmpeg-7.0.2.tar.xz && cd ffmpeg-7.0.2 && \
    ./configure \
      --enable-gpl \
      --enable-version3 \
      --enable-libfreetype \
      --enable-libfontconfig \
      --enable-libfribidi \
      --enable-libass \
      --enable-libx264 \
      --enable-libx265 \
      --enable-libvpx \
      --enable-libopus \
      --enable-libvorbis \
      --enable-nonfree \
      --enable-static \
      --disable-debug \
      --disable-shared && \
    make -j$(nproc) && make install && \
    cd / && rm -rf /build

# Confirm FFmpeg version
RUN ffmpeg -version

# Install n8n globally
RUN npm install -g n8n@latest

# Install Coqui TTS globally
RUN git clone https://github.com/coqui-ai/TTS.git /coqui \
 && cd /coqui \
 && pip install --upgrade pip \
 && pip install -r requirements.txt \
 && pip install .

# Working directory
WORKDIR /app

# Expose n8n port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
