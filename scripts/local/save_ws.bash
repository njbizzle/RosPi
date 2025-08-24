#!/bin/bash

source scripts/bootstrap.bash

export CONTAINER_ID=$(docker ps -aqf "name=$CONTAINER_NAME")

docker cp $CONTAINER_ID:/ros_ws/catkin_ws $PROJ_ROOT
