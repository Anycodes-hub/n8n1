FROM node:18-bullseye

# Set up environment variables
ENV N8N_VERSION=1.45.1
ENV NODE_ENV=production

# Install FFmpeg and other tools
RUN apt-get update && apt-get install -y ffmpeg build-essential python3

# Create app directory
WORKDIR /app

# Install N8N globally
RUN npm install --global n8n@$N8N_VERSION

# Expose N8N port
EXPOSE 5678

# Start N8N
CMD ["n8n"]
