FROM node:20.19-bullseye

ENV NODE_ENV=production
ENV PIP_NO_CACHE_DIR=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl git build-essential yasm pkg-config libfreetype6-dev libfontconfig1 \
    libfribidi-dev libass-dev libssl-dev libvorbis-dev libx264-dev libx265-dev \
    libvpx-dev libopus-dev python3 python3-pip python3-venv python3-dev espeak \
    libglib2.0-0 libsm6 libxext6 libxrender1 imagemagick fonts-dejavu-core fonts-dejavu-extra \
    libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /build && cd /build && \
    wget https://ffmpeg.org/releases/ffmpeg-6.0.5.tar.xz && \
    tar -xf ffmpeg-6.0.5.tar.xz && cd ffmpeg-6.0.5 && \
    ./configure --enable-gpl --enable-version3 --enable-libfreetype --enable-libfontconfig --enable-libfribidi --enable-libass --enable-libx264 --enable-libx265 --enable-libvpx --enable-libopus --enable-libvorbis --enable-nonfree || (cat config.log && false) && \
    make -j$(nproc) || (tail -n 100 config.log && false) && \
    make install && \
    cd / && rm -rf /build

RUN ffmpeg -version

RUN npm install -g n8n@latest

RUN git clone https://github.com/coqui-ai/TTS.git /coqui \
 && cd /coqui \
 && pip install --upgrade pip \
 && pip install -r requirements.txt \
 && pip install .

WORKDIR /app

EXPOSE 5678

CMD ["n8n"]
