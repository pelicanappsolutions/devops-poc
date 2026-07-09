FROM node:20-alpine

WORKDIR /app

COPY package.json ./
COPY server.js ./
COPY scripts/smoke-test.js ./scripts/smoke-test.js

ENV NODE_ENV=production
ENV PORT=3000
ENV APP_ENV=container
ENV APP_VERSION=1.0.0

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/healthz || exit 1

USER node

CMD ["node", "server.js"]
