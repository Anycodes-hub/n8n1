FROM node:20.19-bullseye

ENV N8N_VERSION=1.100.1
ENV NODE_ENV=production
ENV PIP_NO_CACHE_DIR=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
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
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN npm install -g n8n@$N8N_VERSION

RUN git clone https://github.com/coqui-ai/TTS.git /app/TTS \
 && cd /app/TTS \
 && pip3 install -r requirements.txt \
 && pip3 install .

RUN pip3 install srt textwrap3 numpy scipy

WORKDIR /app

EXPOSE 5678

CMD ["n8n"]
