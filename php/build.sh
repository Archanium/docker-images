#!/usr/bin/env bash
# Usage: build.sh <tag> <amd64|arm64|manifest>
#   amd64/arm64: build natively for that platform and push byflou/php:php8.3<postfix>-<arch>
#   manifest:    join the two into the multi-arch tag byflou/php:php8.3<postfix>
set -e
LATEST_TAG=$1;
ARCH=$2;
PROJECT="php"
POSTFIX="-${LATEST_TAG}"
if  [[ "${LATEST_TAG}x" = "x" || "${LATEST_TAG}x" = "latestx"  ]]; then
  POSTFIX=""
fi
echo "PostFix: $POSTFIX";
IMAGE="byflou/${PROJECT}:php8.3${POSTFIX}"
case "$ARCH" in
  amd64|arm64)
    docker buildx create --use
    #docker buildx build --pull --output "type=image,store=true" -t php:8.3.36-fpm-bookworm "https://github.com/docker-library/php.git#e3eaff845f7a9f7259c31da54dce0320b47a3bbd:8.3/bookworm/fpm"
    docker buildx build --platform "linux/${ARCH}" --cache-from "type=registry,ref=archanium/${PROJECT}:8.3-buildcache-${ARCH}" --cache-to "type=registry,ref=archanium/${PROJECT}:8.3-buildcache-${ARCH},mode=max" --tag "${IMAGE}-${ARCH}" --push --build-arg PHP_VERSION=8.3.36-fpm-bookworm . -f 8.3.Dockerfile
    ;;
  manifest)
    docker buildx imagetools create --tag "${IMAGE}" "${IMAGE}-amd64" "${IMAGE}-arm64"
    docker buildx imagetools inspect "${IMAGE}"
    ;;
  *)
    echo "Usage: build.sh <tag> <amd64|arm64|manifest>" >&2
    exit 1
    ;;
esac
