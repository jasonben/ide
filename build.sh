#!/usr/bin/env bash

set -e

source .env

check_vars() {
  var_names=("$@")
  for var_name in "${var_names[@]}"; do
    [ -z "${!var_name}" ] && echo "$var_name is unset. Fix by copying .env.sample to .env" && var_unset=true
  done
  [ -n "$var_unset" ] && exit 1
  return 0
}

check_vars IDE_DOCKER_IMAGE IDE_BASE_IMAGE

# why create a localbuilder? Use case? CI cache?
docker buildx create --name localbuilder 2>/dev/null || true

docker buildx use localbuilder
#docker buildx use default

docker buildx build \
  --load \
  --build-arg IDE_BASE_IMAGE="$IDE_BASE_IMAGE" \
  -t "$IDE_DOCKER_IMAGE" .
