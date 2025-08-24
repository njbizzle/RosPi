#!/bin/bash

source scripts/bootstrap.bash

scp scripts/bootstrap.bash $PI_USER@$PI_IP:~/robot

scp $CORE_IMAGE_PATH $PI_USER@$PI_IP:$IMAGE_DIST_REMOTE

ssh $PI_USER@$PI_IP << 'EOF'
  mkdir robot > /dev/null 2>&1
  cd robot
  mkdir images > /dev/null 2>&1
  cd ../..

  source ~/robot/bootstrap.bash -pi
  cd $PI_PROJ_ROOT

  sudo docker load -i $CORE_IMAGE_PATH_REMOTE
EOF
