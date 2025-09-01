#!/bin/bash

# set -e

if [[ $1 != "pi" ]]; then
  export PROJ_ROOT="$(cd  "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
  cd "$PROJ_ROOT"
fi

export WORKSPACE="/robot"
export CONTAINER_NAME="ros_container"

export PI_DOCKER_CONTEXT="pi_remote"
export LOCAL_DOCKER_CONTEXT="default"

export BUILD="$PROJ_ROOT/build"
export IMAGES="$BUILD/images"

export PI_USER="nmurphy"
export PI_IP="100.111.13.29" 
export MAC_IP="100.127.95.45"

export PI_PROJ_ROOT="/home/nmurphy/robot"
export IMAGES_REMOTE="$PI_PROJ_ROOT/images"

export CORE_BASE=ros:noetic-ros-core

export CORE_IMAGE=core

export CORE_IMAGE_PATH="$IMAGES/core.tar.gz"
export CORE_IMAGE_PATH_REMOTE="$IMAGES_REMOTE/core.tar.gz"
