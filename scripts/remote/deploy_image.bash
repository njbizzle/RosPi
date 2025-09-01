#!/bin/bash

source scripts/bootstrap.bash
docker context use $PI_DOCKER_CONTEXT

scp scripts/bootstrap.bash $PI_USER@$PI_IP:~/robot

tailscale file cp $CORE_IMAGE_PATH $PI_IP:
# scp $CORE_IMAGE_PATH $PI_USER@$PI_IP:$IMAGES_REMOTE

ssh $PI_USER@$PI_IP << 'EOF'
  source ~/robot/bootstrap.bash -pi

  rm $CORE_IMAGE_PATH_REMOTE
  mkdir -p ~/robot/images > /dev/null 2>&1

  sudo tailscale file get ~/robot/images

  cd $PI_PROJ_ROOT

  sudo docker load -i $CORE_IMAGE_PATH_REMOTE
EOF
