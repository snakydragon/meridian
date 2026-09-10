# Meridian DLMM agent — containerized run
# Reference: meridian-run-plan.md (Engineering notes call for Node 22+ ESM)
# Base pinned for reproducibility. Pull via: docker pull node:22.23.2-bookworm-slim
FROM node:22.23.2-bookworm-slim

WORKDIR /meridian

# Copy lockfile first for cache-friendly install, then the rest
COPY package*.json ./
RUN npm ci || npm install

COPY . .

# Never run as root inside the container
RUN addgroup -S meridian && adduser -S meridian -G meridian \
  && chown -R meridian:meridian /meridian
USER meridian

CMD ["node", "index.js"]
