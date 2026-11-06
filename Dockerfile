FROM node:22-alpine AS builder

WORKDIR /build

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build
RUN npm prune --omit=dev

# ---- runtime ----
FROM node:22-alpine
WORKDIR /app

COPY --from=builder /build/dist ./dist
COPY --from=builder /build/node_modules ./node_modules
COPY --from=builder /build/package.json ./package.json

RUN npm install -g supergateway@3.4.3
RUN npm link

EXPOSE 5000

CMD ["supergateway", \
    "--stdio", "mcp-sqlserver", \
    "--outputTransport", "streamableHttp", \
    "--stateful", \
    "--sessionTimeout", "1800000", \
    "--port", "5000", \
    "--streamableHttpPath", "/mcp", \
    "--healthEndpoint", "/health"]