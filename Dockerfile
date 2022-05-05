FROM node:16.15.0-bullseye-slim

WORKDIR /app
COPY . .
RUN set -e; npm install --production

CMD ["node", "index.js"]
