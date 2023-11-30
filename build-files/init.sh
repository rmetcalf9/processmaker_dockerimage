#!/bin/bash
set -ex

if [[ "E" != "E${ENVFILE}" ]]; then
  source ${ENVFILE}
fi

while ! mysqladmin ping -u pm -ppass -h ${PM_DB_HOST} -P ${PM_DB_PORT} --silent; do
    echo "Waiting for mysql"
    sleep 1
done

if [ "E${DATA_DB_ENGINE}" = "E" ]; then
  DATA_DB_ENGINE=InnoDB
fi

if [[ "E${PM_INITIAL_ADMIN_PASS}" = "E" ]]; then
  PM_INITIAL_ADMIN_PASS=admin123
fi

created_files=(".env" "/code/pm4/storage/oauth-private.key" "/code/pm4/storage/oauth-public.key")

# Check if any of the output files are present and if they are delete them.
for t in ${created_files[@]}; do
  base_name=$(basename ${t})
  if [[ -f ${t} ]]; then
    rm ${t}
  fi
  if [[ -f /statefiles/${base_name} ]]; then
    rm /statefiles/${base_name}
  fi
done

SKIP_EXECUTORS=TRUE

php artisan processmaker:install --no-interaction \
--url=${APP_URL} \
--broadcast-host=${PM_BROADCAST_HOST} \
--username=admin \
--password=${PM_INITIAL_ADMIN_PASS} \
--email=admin@processmaker.com \
--first-name=Admin \
--last-name=User \
--db-host=${PM_DB_HOST} \
--db-port=${PM_DB_PORT} \
--db-name=${PM_DB_NAME} \
--db-username=${PM_DB_USERNAME} \
--db-password=${PM_DB_PASSWORD} \
--data-driver=mysql \
--data-host=${PM_DB_HOST} \
--data-port=${PM_DB_PORT} \
--data-name=${PM_DB_NAME} \
--data-username=${PM_DB_USERNAME} \
--data-password=${PM_DB_PASSWORD} \
--redis-host=redis

## Fixes to .env file. These appear AFTER so should override
echo "" >> .env
echo "# RJM Fixes to generated .env file" >> .env
echo "PROCESSMAKER_SCRIPTS_DOCKER=/usr/local/bin/docker" >> .env
echo "PROCESSMAKER_SCRIPTS_DOCKER_MODE=copying" >> .env
echo "LARAVEL_ECHO_SERVER_AUTH_HOST=http://localhost" >> .env
echo "SESSION_SECURE_COOKIE=false" >> .env
echo "SESSION_DOMAIN=" >> .env


echo "Saving required state to volume"
for t in ${created_files[@]}; do
  base_name=$(basename ${t})
  if [[ ! -f ${t} ]]; then
    echo "ERROR install process did not create ${t}"
    exit 1
  fi
  cp ${t} /statefiles/${base_name}
done

###supervisord --nodaemon
exit 0
