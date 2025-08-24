#!/bin/bash

source scripts/bootstrap.bash

open -a XQuartz
export DISPLAY=:0
xhost + $PI_IP

scp scripts/bootstrap.bash $PI_USER@$PI_IP:~/robot

ssh $PI_USER@$PI_IP << EOF
  source ~/robot/bootstrap.bash pi
  cd \$PI_PROJ_ROOT

  sudo docker stop \$CONTAINER_NAME
  sudo docker rm \$CONTAINER_NAME
  
  sudo docker run \
    -e DISPLAY=\$MAC_IP:0 \
    --privileged \
    --user ros \
    --name \$CONTAINER_NAME \
    --network host \
    \$CORE_IMAGE \
    $@
EOF

