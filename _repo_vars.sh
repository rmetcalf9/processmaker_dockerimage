#!/bin/bash

export PROJECT_NAME=${PWD##*/}          # to assign to a variable
export PROJECT_NAME=${PROJECT_NAME:-/}
export BUILD_IMAGE_NAME_AND_TAG=${PROJECT_NAME}_build_image:local

source ./statefiles/inp_env_file
