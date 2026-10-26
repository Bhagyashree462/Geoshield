# Multi-stage Dockerfile for GeoShield (FastAPI + Next.js)
FROM node:20-slim AS frontend-builder
WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm ci

COPY frontend/ ./
ENV NEXT_TELEMETRY_DISABLED=1
RUN npm run build

FROM python:3.11-slim AS runner
WORKDIR /app

# Install Node.js runtime for Next.js
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Backend dependencies
COPY backend/requirements.txt ./backend/requirements.txt
RUN pip install --no-cache-dir -r ./backend/requirements.txt

# Copy Backend codebase
COPY backend/ ./backend/

# Copy Built Frontend
COPY --from=frontend-builder /app/frontend ./frontend

# Copy start script
COPY start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 3000

ENV PORT=3000

CMD ["/app/start.sh"]
