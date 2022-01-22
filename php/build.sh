#!/usr/bin/env bash
LATEST_TAG=$1;
PROJECT="php"
POSTFIX="-${LATEST_TAG}"
if  [[ "${LATEST_TAG}x" = "latestx" ]]; then
  POSTFIX=""
fi
docker build --quiet --tag "byflou/${PROJECT}:php8.0${POSTFIX}" --build-arg PHP_VERSION=8.0-fpm .
docker build --quiet --tag "byflou/${PROJECT}:php8.1${POSTFIX}" --build-arg PHP_VERSION=8.1-fpm --tag "byflou/${PROJECT}:${LATEST_TAG}" .
if [[ "${SNYK_ACCEPTED}x" = "1x" ]]; then
  echo "Scanning: \"byflou/${PROJECT}:php8.0${POSTFIX}\""
  docker scan --file ./Dockerfile "byflou/${PROJECT}:php8.0${POSTFIX}"
  echo "Scanning: \"byflou/${PROJECT}:php8.1${POSTFIX}\""
  docker scan --file ./Dockerfile "byflou/${PROJECT}:php8.1${POSTFIX}"
else
  echo "Not scanning any images"
fi
docker push --quiet --all-tags "byflou/${PROJECT}"