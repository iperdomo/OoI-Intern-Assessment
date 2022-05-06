FROM node:16.15.0-alpine

WORKDIR /app
COPY . .
RUN set -e; npm install --production

CMD ["node", "index.js"]
