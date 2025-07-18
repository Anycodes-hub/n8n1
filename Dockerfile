FROM node:20.19-bullseye

# Environment variables
ENV NODE_ENV=production
ENV PIP_NO_CACHE_DIR=1
ENV PYTHONUNBUFFERED=1

# Install dependencies
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

# Install latest n8n globally
RUN npm install -g n8n@latest

# Clone and install latest Coqui TTS
RUN git clone https://github.com/coqui-ai/TTS.git /coqui
WORKDIR /coqui
RUN python3 -m venv tts-env
RUN . tts-env/bin/activate && pip install --upgrade pip
RUN . tts-env/bin/activate && pip install -r requirements.txt
RUN . tts-env/bin/activate && pip install .

# Set working directory for n8n
WORKDIR /app

# Expose n8n port
EXPOSE 5678

# Default command to run n8n
CMD ["n8n"]
