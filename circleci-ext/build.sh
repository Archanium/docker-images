#!/usr/bin/env bash
docker buildx create --use
docker buildx build \
   --cache-from type=registry,ref=archanium/dreamshop-php:8.0-buildcache \
   --cache-to type=registry,ref=archanium/dreamshop-php:8.0-buildcache,mode=max \
   --tag "archanium/dreamshop-php:8.0" --push --file Dockerfile  .
docker buildx build \
   --cache-from type=registry,ref=archanium/dreamshop-php:8.0-browsers-buildcache \
   --cache-to type=registry,ref=archanium/dreamshop-php:8.0-browsers-buildcache,mode=max \
   --tag "archanium/dreamshop-php:8.0-browsers" --push --file browsers.Dockerfile  .
docker buildx build \
   --cache-from type=registry,ref=archanium/dreamshop-builder:8.0-buildcache \
   --cache-to type=registry,ref=archanium/dreamshop-builder:8.0-buildcache,mode=max \
   --tag "archanium/dreamshop-builder:8.0" --push --file builder.Dockerfile  .

docker buildx build \
   --cache-from type=registry,ref=archanium/dreamshop-php:8.1-buildcache \
   --cache-to type=registry,ref=archanium/dreamshop-php:8.1-buildcache,mode=max \
   --build-arg PHP_VERSION=8.1 \
   --tag "archanium/dreamshop-php:8.1" --push --file Dockerfile  .
docker buildx build \
   --cache-from type=registry,ref=archanium/dreamshop-php:8.1-browsers-buildcache \
   --cache-to type=registry,ref=archanium/dreamshop-php:8.1-browsers-buildcache,mode=max \
   --build-arg PHP_VERSION=8.1-browsers \
   --tag "archanium/dreamshop-php:8.1-browsers" --push --file browsers.Dockerfile  .
docker buildx build \
   --cache-from type=registry,ref=archanium/dreamshop-builder:8.1-buildcache \
   --cache-to type=registry,ref=archanium/dreamshop-builder:8.1-buildcache,mode=max \
   --build-arg PHP_VERSION=8.1-browsers \
   --tag "archanium/dreamshop-builder:8.1" --push --file builder.Dockerfile  .

# --- PHP 8.3 "next" CI executors ---------------------------------------------
# The dreamshop suite still runs on :8.1 (see .circleci/continue_config.yml).
# These :8.3 images exist so the opt-in "test-next-php" CI path can run the same
# suite on PHP 8.3 without changing what the default pipeline uses. Mirror of the
# 8.1 blocks above; upstream cimg/php:8.3 and cimg/php:8.3-browsers both exist.
docker buildx build \
   --cache-from type=registry,ref=archanium/dreamshop-php:8.3-buildcache \
   --cache-to type=registry,ref=archanium/dreamshop-php:8.3-buildcache,mode=max \
   --build-arg PHP_VERSION=8.3 \
   --tag "archanium/dreamshop-php:8.3" --push --file Dockerfile  .
docker buildx build \
   --cache-from type=registry,ref=archanium/dreamshop-php:8.3-browsers-buildcache \
   --cache-to type=registry,ref=archanium/dreamshop-php:8.3-browsers-buildcache,mode=max \
   --build-arg PHP_VERSION=8.3-browsers \
   --tag "archanium/dreamshop-php:8.3-browsers" --push --file browsers.Dockerfile  .
docker buildx build \
   --cache-from type=registry,ref=archanium/dreamshop-builder:8.3-buildcache \
   --cache-to type=registry,ref=archanium/dreamshop-builder:8.3-buildcache,mode=max \
   --build-arg PHP_VERSION=8.3-browsers \
   --tag "archanium/dreamshop-builder:8.3" --push --file builder.Dockerfile  .
