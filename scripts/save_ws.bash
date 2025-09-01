#!/bin/bash

source scripts/bootstrap.bash

export CONTAINER_ID=$(docker ps -aqf "name=$CONTAINER_NAME")

rm -rf $PROJ_ROOT/catkin_ws
docker cp $CONTAINER_ID:/ros_ws/catkin_ws $PROJ_ROOT
