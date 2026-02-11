#!/bin/bash
set -e

# Image name and tag
IMAGE_NAME="custom-frappe-apps"
TAG="latest"

# Check if apps.json exists
if [ ! -f "apps.json" ]; then
    echo "Error: apps.json not found in the current directory."
    exit 1
fi

# Encode apps.json to base64
echo "Encoding apps.json..."
APPS_JSON_BASE64=$(base64 < apps.json)

# Detect container runtime (podman or docker)
if command -v podman &> /dev/null; then
    RUNTIME="podman"
elif command -v docker &> /dev/null; then
    RUNTIME="docker"
else
    echo "Error: Neither podman nor docker found."
    exit 1
fi

echo "Building image using $RUNTIME..."
$RUNTIME build \
  --build-arg=APPS_JSON_BASE64="${APPS_JSON_BASE64}" \
  -f Containerfile \
  -t ${IMAGE_NAME}:${TAG} \
  .

echo "Build complete: ${IMAGE_NAME}:${TAG}"
