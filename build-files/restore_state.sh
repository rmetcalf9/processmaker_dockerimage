#!/bin/bash

echo "Restoring state"

if [[ "E" != "E${ENVFILE}" ]]; then
  echo " environment supplied - ${ENVFILE}"
  source ${ENVFILE}
fi

if [[ ! -f /statefiles/.env ]]; then
  echo "ERROR /statefiles/.env is missing can not start"
  echo "     is using volumes was the init process run on the right node???"
  exit 1
fi

cp /statefiles/.env .env
# This is after .env produced by init so passed env overrides
if [[ "E" != "E${ENVFILE}" ]]; then
  cat ${ENVFILE} >> .env
fi
cp /statefiles/oauth-private.key /code/pm4/storage/oauth-private.key
cp /statefiles/oauth-public.key /code/pm4/storage/oauth-public.key

echo "Restore state complete"
exit 0
