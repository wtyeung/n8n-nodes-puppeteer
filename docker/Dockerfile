FROM docker.n8n.io/n8nio/n8n

USER root

# Install Chrome dependencies and Chrome
RUN apk add --no-cache \
    chromium \
    nss \
    glib \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    udev \
    ttf-liberation \
    font-noto-emoji

# Tell Puppeteer to use installed Chrome instead of downloading it
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Pre-install the package with full npm (bypasses n8n's --install-strategy=shallow)
# Using || true so a failed install does NOT break the Docker build
ENV N8N_CUSTOM_EXTENSIONS=/home/node/.n8n/custom
RUN mkdir -p /home/node/.n8n/custom && \
    cd /home/node/.n8n/custom && \
    npm init -y && \
    npm install --save @wtyeung/n8n-nodes-puppeteer || \
    (echo "WARNING: Failed to install @wtyeung/n8n-nodes-puppeteer - n8n will start without it" && true) && \
    chown -R node:node /home/node/.n8n/custom

# Copy our custom entrypoint
COPY docker-custom-entrypoint.sh /docker-custom-entrypoint.sh
RUN chmod +x /docker-custom-entrypoint.sh && \
    chown node:node /docker-custom-entrypoint.sh

USER node

ENTRYPOINT ["/docker-custom-entrypoint.sh"]
