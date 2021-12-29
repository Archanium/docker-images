#!/usr/bin/env bash
if [[ "${CIRCLE_BRANCH}x" = "masterx" ]]; then
  TAGNAME="latest"
else
  TAGNAME="${CIRCLE_BRANCH}"
fi

export DOCKER_BUILDKIT=1
UNAME="$DOCKERHUB_USERNAME"
UPASS="$DOCKERHUB_PASS"

function docker_tag_exists() {
    TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${UNAME}'", "password": "'${UPASS}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
    curl --silent -f --head -lL https://hub.docker.com/v2/repositories/$1/tags/$2/ > /dev/null
}

echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin;
pushd ./$1 
docker build --tag "byflou/$1:${TAGNAME}" .

docker push "byflou/$1:${TAGNAME}"
