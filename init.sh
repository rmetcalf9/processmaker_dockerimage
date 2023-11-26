#!/bin/bash

source ./_repo_vars.sh
echo "Running database init process for project ${PROJECT_NAME}"


docker exec -i dev_machine_utilities_dmu-processmakermysqldb.1.nej79426mumtshfvp54f1b3dz mysql -pprocessmakermysqldb_examplepassword < ./_init_setup_database.sql


CUR_DIR=$(pwd)

docker run --rm -it --name ${PROJECT_NAME}_init \
 --network main_net \
 -v "/var/run/docker.sock:/var/run/docker.sock" \
 -v "${CUR_DIR}/statefiles:/statefiles" \
 -e "ENVFILE=/statefiles/inp_env_file" \
 ${BUILD_IMAGE_NAME_AND_TAG} bash init.sh

exit 0
