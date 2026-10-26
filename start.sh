#!/bin/bash
set -e

PORT="${PORT:-3000}"

echo "Starting GeoShield FastAPI backend on port 8000..."
cd /app/backend
python3 -m uvicorn app.main:app --host 127.0.0.1 --port 8000 &

echo "Starting GeoShield Next.js frontend on port $PORT..."
cd /app/frontend
exec npm run start -- -p "$PORT"
