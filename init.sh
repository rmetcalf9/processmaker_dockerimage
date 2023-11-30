#!/bin/bash

source ./_repo_vars.sh
echo "Running database init process for project ${PROJECT_NAME}"


CUR_DIR=$(pwd)

# Wipe the database data
docker run --rm -i --network=main_net --name=processmaker_init_db ${MARIADB_IMAGE_FOR_CLIENT} mysql -h "${PM_DB_HOST}" -P "${PM_DB_PORT}" -p${TESTING_DB_PASS} < ./_init_setup_database.sql
RES=$?
if [[ ${RES} -ne 0 ]]; then
  echo "Docker command to init db failed"
  exit ${RES}
fi

docker run --rm -it --name ${PROJECT_NAME}_init \
 --network main_net \
 -v "/var/run/docker.sock:/var/run/docker.sock" \
 -v "${CUR_DIR}/statefiles:/statefiles" \
 -e "ENVFILE=/statefiles/inp_env_file" \
 -p ${PM_APP_PORT}:80 \
 ${BUILD_IMAGE_NAME_AND_TAG} bash init.sh

exit 0
