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
   --arg PHP_VERSION=8.1 \
   --tag "archanium/dreamshop-php:8.1" --push --file Dockerfile  .
docker buildx build \
   --cache-from type=registry,ref=archanium/dreamshop-php:8.1-browsers-buildcache \
   --cache-to type=registry,ref=archanium/dreamshop-php:8.1-browsers-buildcache,mode=max \
   --arg PHP_VERSION=8.1-browsers \
   --tag "archanium/dreamshop-php:8.1-browsers" --push --file browsers.Dockerfile  .
docker buildx build \
   --cache-from type=registry,ref=archanium/dreamshop-builder:8.1-buildcache \
   --cache-to type=registry,ref=archanium/dreamshop-builder:8.1-buildcache,mode=max \
   --arg PHP_VERSION=8.1-browsers \
   --tag "archanium/dreamshop-builder:8.1" --push --file builder.Dockerfile  .
