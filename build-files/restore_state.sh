#!/bin/bash

if [[ "E" != "E${ENVFILE}" ]]; then
  source ${ENVFILE}
fi

cp /statefiles/.env .env
cp /statefiles/oauth-private.key /code/pm4/storage/oauth-private.key
cp /statefiles/oauth-public.key /code/pm4/storage/oauth-public.key
