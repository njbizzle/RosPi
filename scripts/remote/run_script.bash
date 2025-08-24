#!/bin/bash

source scripts/bootstrap.bash

scp scripts/bootstrap.bash $PI_USER@$PI_IP:~/robot

mkdir .temp > /dev/null 2>&1
mv scripts/remote/$1 .temp/transfer.bash
scp .temp/transfer.bash $PI_USER@$PI_IP:~/.temp
rm -rf .temp

ssh $PI_USER@$PI_IP < 'EOF'
  source ~/robot/bootstrap.bash pi
  source ~/.temp/transfer.bash
  cd $PI_PROJ_ROOT

  rm -rf .temp
EOF
