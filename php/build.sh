#!/usr/bin/env bash
LATEST_TAG=$1;
PROJECT="php"
POSTFIX="-${LATEST_TAG}"
if  [[ "${LATEST_TAG}x" = "latestx" ]]; then
  POSTFIX=""
fi
docker build --quiet --tag "byflou/${PROJECT}:php8.0${POSTFIX}" --build-arg PHP_VERSION=8.0-fpm .
docker build --quiet --tag "byflou/${PROJECT}:php8.1${POSTFIX}" --build-arg PHP_VERSION=8.1-fpm --tag "byflou/${PROJECT}:${LATEST_TAG}" .
if [[ $SNYK_ACCEPTED = 1 ]]; then
  docker scan "byflou/${PROJECT}:php8.0${POSTFIX}" --file ./Dockerfile
  docker scan "byflou/${PROJECT}:php8.1${POSTFIX}" --file ./Dockerfile
fi;
docker push --all-tags "byflou/${PROJECT}"