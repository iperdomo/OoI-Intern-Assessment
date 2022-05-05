FROM node:16.15.0-bullseye-slim as builder

WORKDIR /app
COPY . .

RUN set -e; \
    npm install --no-progress && \
    npm run build

FROM nginx:1.21.6-alpine

COPY --from=builder /app/build/ /usr/share/nginx/html/
COPY --from=builder /app/proxy/conf.d /etc/nginx/conf.d/
