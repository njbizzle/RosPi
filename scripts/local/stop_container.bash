#!/bin/bash

source scripts/bootstrap.bash

source scripts/save_ws_from_local.bash
docker stop $CONTAINER_NAME
