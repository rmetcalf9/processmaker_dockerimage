#!/bin/bash

source ./_repo_vars.sh
echo "Running database init process for project ${PROJECT_NAME}"

CUR_DIR=$(pwd)

docker run --rm -it --name ${PROJECT_NAME}_runinit \
 --network main_net \
 -v "/var/run/docker.sock:/var/run/docker.sock" \
 -v "${CUR_DIR}/statefiles:/statefiles" \
 -e "PM_APP_URL=${PM_APP_URL}" \
 -e "PM_APP_PORT=${PM_APP_PORT}" \
 -e "PM_BROADCASTER_PORT=${PM_BROADCASTER_PORT}" \
 -e "PM_DOCKER_SOCK=${PM_DOCKER_SOCK}" \
 -e "PM_DB_HOST=${PM_DB_HOST}" \
 -e "PM_DB_PORT=${PM_DB_PORT}" \
 -e "PM_DB_NAME=${PM_DB_NAME}" \
 -e "PM_DB_USERNAME=${PM_DB_USERNAME}" \
 -e "PM_DB_PASSWORD=${PM_DB_PASSWORD}" \
 -e "PM_REDIS_HOST=${PM_REDIS_HOST}" \
 ${BUILD_IMAGE_NAME_AND_TAG} bash init.sh

exit 0
