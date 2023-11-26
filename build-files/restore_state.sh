#!/bin/bash

echo "Restoring state"

if [[ "E" != "E${ENVFILE}" ]]; then
  echo " environment supplied - ${ENVFILE}"
  source ${ENVFILE}
fi

cp /statefiles/.env .env
# This is after .env produced by init so passed env overrides
if [[ "E" != "E${ENVFILE}" ]]; then
  cat ${ENVFILE} >> .env
fi
cp /statefiles/oauth-private.key /code/pm4/storage/oauth-private.key
cp /statefiles/oauth-public.key /code/pm4/storage/oauth-public.key

echo "Restore state complete"
