#!/bin/bash

set -e

source /opt/ros/noetic/setup.bash

echo "Provided arguments: $@"

if [ -e "/dev/gpiochip0" ]; then
  # echo "testing 0"
  sudo chown root:gpio /dev/gpiochip0
  sudo chmod 660 /dev/gpiochip0
fi

if [ -e "/dev/spidev0.0" ]; then
  # echo "testing 1"
  sudo chown root:spi /dev/spidev0.0
  sudo chmod 660 /dev/spidev0.0
fi


# sudo rosdep init
rosdep update

cd /ros_ws/catkin_ws/ORB_SLAM3_NOETIC

export ROS_PACKAGE_PATH=/ros_ws/catkin_ws/ORB_SLAM3_NOETIC/Examples/ROS:$ROS_PACKAGE_PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

source ./build_ros.sh

exec $@
