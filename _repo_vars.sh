#!/bin/bash

export PROJECT_NAME=${PWD##*/}          # to assign to a variable
export PROJECT_NAME=${PROJECT_NAME:-/}
export BUILD_IMAGE_NAME_AND_TAG=${PROJECT_NAME}_build_image:local

export PM_APP_URL=http://localhost
export PM_APP_PORT=8080
export PM_BROADCASTER_PORT=6004
export PM_DOCKER_SOCK=/var/run/docker.sock
export PM_DB_HOST=dmu-processmakermysqldb
export PM_DB_PORT=3306
export PM_DB_NAME=processmaker
export PM_DB_USERNAME=pm
export PM_DB_PASSWORD=pass
export PM_REDIS_HOST=redis
