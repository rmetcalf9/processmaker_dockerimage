#!/bin/bash

source ./_repo_vars.sh
echo "Running process for project ${PROJECT_NAME}"

CUR_DIR=$(pwd)

echo "Using ${PM_APP_PORT}"

docker run --rm -it --name ${PROJECT_NAME}_run \
 --network main_net \
 -v "/var/run/docker.sock:/var/run/docker.sock" \
 -v "${CUR_DIR}/statefiles:/statefiles" \
 -e "ENVFILE=/statefiles/inp_env_file" \
 -p ${PM_APP_PORT}:80 \
 -p 6001:6001 \
 ${BUILD_IMAGE_NAME_AND_TAG}

exit 0
