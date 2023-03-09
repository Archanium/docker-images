#!/usr/bin/env bash
docker build --tag "archanium/dreamshop-php:8.0" --push --file Dockerfile .
docker build --tag "archanium/dreamshop-php:8.0-browsers" --push --file browsers.Dockerfile .
docker build --tag "archanium/dreamshop-builder:8.0"  --push --file builder.Dockerfile .
