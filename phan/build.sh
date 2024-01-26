#!/usr/bin/env bash
set -e
LATEST_TAG=$1;
PROJECT="dreamshop-phan"
POSTFIX="-${LATEST_TAG}"
if  [[ "${LATEST_TAG}x" = "x" || "${LATEST_TAG}x" = "latestx"  ]]; then
  POSTFIX=""
fi
echo "PostFix: $POSTFIX";
docker build --tag "archanium/${PROJECT}:8.0${POSTFIX}" --tag "ghcr.io/archanium/${PROJECT}:8.0${POSTFIX}" -f php8.0.Dockerfile .
docker build --tag "archanium/${PROJECT}:8.1${POSTFIX}" --tag "ghcr.io/archanium/${PROJECT}:8.1${POSTFIX}" -f php8.1.Dockerfile .
#docker push --all-tags "ghcr.io/archanium/${PROJECT}"
docker push --all-tags "archanium/${PROJECT}"