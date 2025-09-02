#!/bin/bash

source scripts/bootstrap.bash

export CONTAINER_ID=$(docker ps -aqf "name=$CONTAINER_NAME")

rm -rf $PROJ_ROOT/catkin_ws
mkdir catkin_ws

docker cp $CONTAINER_ID:/ros_ws/catkin_ws/src $PROJ_ROOT/catkin_ws/src
docker cp $CONTAINER_ID:/ros_ws/catkin_ws/.catkin_workspace $PROJ_ROOT/catkin_ws/.catkin_workspace
