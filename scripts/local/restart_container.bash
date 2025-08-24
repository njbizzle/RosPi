#!/bin/bash

source scripts/bootstrap.bash

source scripts/stop_container.bash
docker rm $CONTAINER_NAME > /dev/null 2>&1

open -a XQuartz
export DISPLAY=host.docker.internal:0
xhost + 127.0.0.1

docker run \
  -it \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  --user ros \
  --name $CONTAINER_NAME \
  $CORE_IMAGE \
  $@
