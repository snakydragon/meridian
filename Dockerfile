# Meridian DLMM agent — containerized run
# Reference: meridian-run-plan.md (Engineering notes call for Node 22+ ESM)
# Base pinned for reproducibility. Pull via: docker pull node:22.23.2-bookworm-slim
FROM node:22.23.2-bookworm-slim

WORKDIR /meridian

# Copy lockfile + patch script first: postinstall runs `scripts/patch-anchor.js`
# during npm ci, before the rest of the repo is copied.
COPY package*.json ./
COPY scripts ./scripts
RUN npm ci || npm install

COPY . .

# Never run as root inside the container
RUN groupadd --system meridian && useradd --system --gid meridian --home-dir /meridian meridian \
  && chown -R meridian:meridian /meridian
USER meridian

CMD ["node", "index.js"]
