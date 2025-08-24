#!/bin/bash

# set -e

if [[ $1 != "pi" ]]; then
  export PROJ_ROOT="$(cd  "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
  cd "$PROJ_ROOT"
fi

export WORKSPACE="/robot"
export CONTAINER_NAME="ros_container"

export DIST="$PROJ_ROOT/dist"
export IMAGE_DIST="$DIST/images"

export PI_USER="nmurphy"
export PI_IP="10.42.0.1"
export MAC_IP="10.42.0.198"

export PI_PROJ_ROOT="/home/nmurphy/robot"
export IMAGE_DIST_REMOTE="$PI_PROJ_ROOT/images"

export PI_REQUIREMENTS="$PROJ_ROOT/pi_requirements.txt"

export CORE_BASE=ros:noetic-ros-core
# export DESKTOP_BASE=seunmul/ros:noetic-full-arm64

export CORE_IMAGE=core
# export DESKTOP_IMAGE=desktop

export CORE_IMAGE_PATH="$IMAGE_DIST/core.tar.gz"
export CORE_IMAGE_PATH_REMOTE="$IMAGE_DIST_REMOTE/core.tar.gz"
# export DESKTOP_IMAGE_PATH="$IMAGE_DIST/desktop.tar"


