#!/bin/bash

source ./_repo_vars.sh
echo "Building project ${PROJECT_NAME}"

docker build --build-arg="PM_VERSION=4.1.21" . -t ${BUILD_IMAGE_NAME_AND_TAG}
