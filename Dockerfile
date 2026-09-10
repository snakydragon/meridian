# Meridian DLMM agent — containerized run
# Reference: meridian-run-plan.md (Engineering notes call for Node 22+ ESM)
FROM node:22-alpine

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
