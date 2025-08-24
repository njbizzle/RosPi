#!/bin/bash

source scripts/bootstrap.bash

open -a XQuartz
export DISPLAY=:0
xhost + $PI_IP

scp scripts/bootstrap.bash $PI_USER@$PI_IP:~/robot

ssh $PI_USER@$PI_IP << EOF
  source ~/robot/bootstrap.bash pi
  cd \$PI_PROJ_ROOT
  
  sudo docker exec $CONTAINER_NAME bash -lc "$@"
EOF
