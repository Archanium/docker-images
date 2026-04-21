#!/usr/bin/env bash
set -e
LATEST_TAG=$1;
PROJECT="dreamshop-phan"
POSTFIX="-${LATEST_TAG}"
if  [[ "${LATEST_TAG}x" = "x" || "${LATEST_TAG}x" = "latestx"  ]]; then
  POSTFIX=""
fi
echo "PostFix: $POSTFIX";
docker buildx create --use
docker buildx inspect --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 \
              --tag "archanium/${PROJECT}:8.3${POSTFIX}" \
              -f php8.3.Dockerfile --push .