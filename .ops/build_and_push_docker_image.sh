#!/usr/bin/env bash

if [[ "{$CIRCLE_BRANCH}x" == "masterx" ]]; then
  TAGNAME="latest"
else
  TAGNAME="${CIRCLE_BRANCH}"
fi
export DOCKER_BUILDKIT=1
echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin;
docker build --tag "byflou/$1:${TAGNAME}" --file Dockerfile ./$1

docker push "byflou/$1:${TAGNAME}"
