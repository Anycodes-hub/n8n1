FROM node:20.19-bullseye

# Set up environment variables
ENV N8N_VERSION=1.100.1
ENV NODE_ENV=production

# Install FFmpeg and other tools
RUN apt-get update && apt-get install -y ffmpeg build-essential python3

# Create working directory
WORKDIR /app

# Install N8N globally
RUN npm install --global n8n@$N8N_VERSION

# Expose default N8N port
EXPOSE 5678

# Start N8N
CMD ["n8n"]
