#!/usr/bin/env bash
set -e
LATEST_TAG=$1;
PROJECT="php"
POSTFIX="-${LATEST_TAG}"
if  [[ "${LATEST_TAG}x" = "x" || "${LATEST_TAG}x" = "latestx"  ]]; then
  POSTFIX=""
fi
echo "PostFix: $POSTFIX";
docker buildx create --use
docker buildx build --cache-from type=registry,ref=byflou/${PROJECT}:8.0-buildcache --cache-to type=registry,ref=archanium/${PROJECT}:8.0-buildcache,mode=max --tag "byflou/${PROJECT}:php8.0${POSTFIX}" --tag "ghcr.io/archanium/${PROJECT}:php8.0${POSTFIX}" --build-arg PHP_VERSION=8.0-fpm .
docker buildx build --cache-from type=registry,ref=byflou/${PROJECT}:8.3-buildcache --cache-to type=registry,ref=archanium/${PROJECT}:8.3-buildcache,mode=max --tag "byflou/${PROJECT}:php8.3${POSTFIX}" --tag "ghcr.io/archanium/${PROJECT}:php8.3${POSTFIX}" --build-arg PHP_VERSION=8.3-fpm-bookworm . -f 8.3.Dockerfile
docker push --all-tags "byflou/${PROJECT}"