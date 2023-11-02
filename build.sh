#!/bin/bash

source ./_repo_vars.sh
echo "Building project ${PROJECT_NAME}"

TAG=${BUILD_IMAGE_NAME_AND_TAG}
if [$# -ne 0];
  echo "Tag provided: ${TAG}"
  exit 1
fi

docker build --build-arg="PM_VERSION=4.1.21" . -t ${TAG}

exit 0
