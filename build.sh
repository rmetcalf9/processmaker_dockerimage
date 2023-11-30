#!/bin/bash

source ./_repo_vars.sh
echo "Building project ${PROJECT_NAME}"

TAG=${BUILD_IMAGE_NAME_AND_TAG}
if [ $# -ne 0 ]; then
  TAG=${1}
  echo "Tag provided: ${TAG}"
fi

docker build --build-arg="PM_VERSION=4.8.1" --build-arg="UBUNTU_CONTAINER=ubuntu:22.04" --build-arg="PHP_VER=8.2" . -t ${TAG}

#PM VERSION 4.8.1  - Traits error with PHP 8.1 (Needs 8.2 but I get other error with 8.2)

#PM VERSION 4.5.0  - Invalid route action - same error I got with 4.8.1 on php 8.2

#PM VERSION 4.3.1  - Invalid route action - same error I got with 4.8.1 on php 8.2

#PM VERSION 4.2.28 Build error

#PM VERSION 4.1.21 ORIG VERSION Build error with PHP 8.1


# Orig verison I found 4.1.21

exit 0
