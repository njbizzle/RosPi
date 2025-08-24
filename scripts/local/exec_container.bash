#!/bin/bash

source scripts/bootstrap.bash

docker exec -it $CONTAINER_NAME $@
