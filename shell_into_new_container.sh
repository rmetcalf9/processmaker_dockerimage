#!/bin/bash

source ./_repo_vars.sh
echo "Starting shell in new container instance for project ${PROJECT_NAME}"


CUR_DIR=$(pwd)

docker run --rm -it --name ${PROJECT_NAME}_init \
 --network main_net \
 -v "/var/run/docker.sock:/var/run/docker.sock" \
 -v "${CUR_DIR}/statefiles:/statefiles" \
 -e "ENVFILE=/statefiles/inp_env_file" \
 -p ${PM_APP_PORT}:80 \
 -p 6001:6001 \
 ${BUILD_IMAGE_NAME_AND_TAG} /bin/bash

#TODO remove 6001

exit 0
