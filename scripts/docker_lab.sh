#!/usr/bin/env bash
set -euo pipefail

IMAGE="cgi-devops-practice-app:local"
CONTAINER="cgi-devops-practice-app"

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
docker logs cgi-devops-practice-app
docker exec -it cgi-devops-practice-app sh
docker inspect cgi-devops-practice-app
docker stop cgi-devops-practice-app
docker rm cgi-devops-practice-app
NEXT
