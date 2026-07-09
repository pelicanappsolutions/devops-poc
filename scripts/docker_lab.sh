#!/usr/bin/env bash
set -euo pipefail

IMAGE="devops-poc-app:local"
CONTAINER="devops-poc-app"

echo "Building Docker image..."
docker build -t "$IMAGE" .

echo "Running container..."
docker rm -f "$CONTAINER" 2>/dev/null || true
docker run -d --name "$CONTAINER" -p 3000:3000 "$IMAGE"

echo "Checking running containers..."
docker ps

echo "Testing health endpoint..."
sleep 2
curl -f http://localhost:3000/healthz

echo "Showing logs..."
docker logs --tail=20 "$CONTAINER"


cat <<'NEXT'

Practice these commands:
docker ps
docker images
docker logs devops-poc-app
docker exec -it devops-poc-app sh
docker inspect devops-poc-app
docker stop devops-poc-app
docker rm devops-poc-app
NEXT
