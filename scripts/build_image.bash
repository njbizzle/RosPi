#!/bin/bash

source scripts/bootstrap.bash
docker context use $LOCAL_DOCKER_CONTEXT


# Make the dist dirs and suppress any already exists errors
mkdir $BUILD > /dev/null 2>&1
mkdir $IMAGES > /dev/null 2>&1

BASE=$CORE_BASE
IMAGE=$CORE_IMAGE
IMAGE_PATH=$CORE_IMAGE_PATH
PLATFORM="linux/arm64"

pip freeze > requirements.txt

yes | docker image prune
docker buildx build \
  --rm \
  --build-arg ROS_BASE=$BASE \
  --platform $PLATFORM \
  --progress=plain \
  -t $IMAGE . \
  2>&1 | tee $BUILD/build.log

docker save -o $IMAGE_PATH $IMAGE
# Yes to overwriting existing files
yes | gzip --best $IMAGE_PATH
