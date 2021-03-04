#!/bin/bash

# Get host Docker group id
DOCKER_GID=$(getent group docker | cut -d':' -f3)

echo "Using host Docker group id : $DOCKER_GID"

docker build --build-arg DOCKER_GID=$DOCKER_GID . -t xubuntudesktop
