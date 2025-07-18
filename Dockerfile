FROM node:20.19-bullseye

# Environment
ENV NODE_ENV=production
ENV PIP_NO_CACHE_DIR=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
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
    fonts-dejavu-core \
    fonts-dejavu-extra \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install n8n globally
RUN npm install -g n8n@latest

# Install latest Coqui TTS globally
RUN git clone https://github.com/coqui-ai/TTS.git /coqui \
 && cd /coqui \
 && pip install --upgrade pip \
 && pip install -r requirements.txt \
 && pip install .

# Create working directory
WORKDIR /app

# Expose n8n port
EXPOSE 5678

# Run n8n
CMD ["n8n"]
