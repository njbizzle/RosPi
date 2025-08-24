#!/bin/bash

source scripts/bootstrap.bash

# Make the dist dirs and suppress any already exists errors
mkdir $DIST > /dev/null 2>&1
mkdir $IMAGE_DIST > /dev/null 2>&1

BASE=$CORE_BASE
IMAGE=$CORE_IMAGE
IMAGE_PATH=$CORE_IMAGE_PATH
PLATFORM="linux/arm64"

pip freeze > requirements.txt
cat $PI_REQUIREMENTS >> requirements.txt

docker buildx build \
  --rm \
  --build-arg ROS_BASE=$BASE \
  --platform $PLATFORM \
  --progress=plain \
  -t $IMAGE . \
  2>&1 | tee build.log

docker save -o $IMAGE_PATH $IMAGE
# Yes to overwriting existing files
yes | gzip --best $IMAGE_PATH
