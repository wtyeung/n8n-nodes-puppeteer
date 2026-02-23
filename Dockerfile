FROM docker.n8n.io/n8nio/n8n

USER root

# Skip Chromium download - remote browser only
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_SKIP_DOWNLOAD=true \
    N8N_CUSTOM_EXTENSIONS=/home/node/.n8n/custom

# Pre-install the package with full npm (not n8n's shallow install)
# This avoids the lru-cache constructor error caused by n8n's --install-strategy=shallow
# Using || true so a failed install does NOT break the Docker build - n8n will still start
RUN mkdir -p /home/node/.n8n/custom && \
    cd /home/node/.n8n/custom && \
    npm init -y && \
    npm install --save @wtyeung/n8n-nodes-puppeteer || \
    (echo "WARNING: Failed to install @wtyeung/n8n-nodes-puppeteer - n8n will start without it" && true) && \
    chown -R node:node /home/node/.n8n/custom

# Copy our custom entrypoint
COPY docker/docker-custom-entrypoint.sh /docker-custom-entrypoint.sh
RUN chmod +x /docker-custom-entrypoint.sh && \
    chown node:node /docker-custom-entrypoint.sh

USER node

ENTRYPOINT ["/docker-custom-entrypoint.sh"]
