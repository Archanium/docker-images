#!/usr/bin/env bash
set -e
LATEST_TAG=$1;
PROJECT="php"
POSTFIX="-${LATEST_TAG}"
if  [[ "${LATEST_TAG}x" = "x" || "${LATEST_TAG}x" = "latestx"  ]]; then
  POSTFIX=""
fi
echo "PostFix: $POSTFIX";
docker build --tag "byflou/${PROJECT}:php8.0${POSTFIX}" --tag "ghcr.io/archanium/${PROJECT}:php8.0${POSTFIX}" --build-arg PHP_VERSION=8.0-fpm .
#docker build --tag "byflou/${PROJECT}:php8.1${POSTFIX}" --build-arg PHP_VERSION=8.1-fpm --tag "byflou/${PROJECT}:${LATEST_TAG}" .
# if [[ "${SNYK_TOKEN}x" != "x" ]]; then
#   echo "Scanning: \"byflou/${PROJECT}:php8.0${POSTFIX}\""
#   #docker scan --file ./Dockerfile --exclude-base "byflou/${PROJECT}:php8.0${POSTFIX}"
#   echo "Scanning: \"byflou/${PROJECT}:php8.1${POSTFIX}\""
#   #docker scan --file ./Dockerfile --exclude-base "byflou/${PROJECT}:php8.1${POSTFIX}"
# else
#   echo "Not scanning any images"
# fi
#docker push --all-tags "ghcr.io/archanium/${PROJECT}"
docker push --all-tags "byflou/${PROJECT}"