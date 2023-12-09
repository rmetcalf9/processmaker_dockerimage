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
 -e "RJM_DOCKER_REPO_URL=${MEMSET_PRIVATEREPO_URL}" \
 -e "RJM_DOCKER_REPO_USER=${MEMSET_PRIVATEREPO_USERNAME}" \
 -e "RJM_DOCKER_REPO_PASS=${MEMSET_PRIVATEREPO_PASSWORD}" \
 -p ${PM_APP_PORT}:80 \
 ${BUILD_IMAGE_NAME_AND_TAG}

exit 0
