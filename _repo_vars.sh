#!/bin/bash

export PROJECT_NAME=${PWD##*/}          # to assign to a variable
export PROJECT_NAME=${PROJECT_NAME:-/}
export BUILD_IMAGE_NAME_AND_TAG=${PROJECT_NAME}_build_image:local

export MARIADB_IMAGE_FOR_CLIENT=mariadb:10.9.8
export TESTING_DB_PASS=testingmysqldb_examplepassword


export METCAROB_DOCKER_EXECUTOR_PYTHON_CONTAINER_VERSION=1.1.12

source ./statefiles/inp_env_file
