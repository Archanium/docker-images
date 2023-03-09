#!/usr/bin/env bash
export DOCKER_BUILDKIT=1

echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin;

