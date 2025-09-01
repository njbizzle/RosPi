#!/bin/bash

set -e

source /opt/ros/noetic/setup.bash

echo "Provided arguments: $@"

sudo chown root:gpio /dev/gpiochip0
sudo chmod 660 /dev/gpiochip0

sudo chown root:spi /dev/spidev0.0
sudo chmod 660 /dev/spidev0.0

exec $@
