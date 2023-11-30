#!/bin/bash


created_files=(".env" "/code/pm4/storage/oauth-private.key" "/code/pm4/storage/oauth-public.key")

for t in ${created_files[@]}; do
  base_name=$(basename ${t})
  if [[ ! -f /statefiles/${base_name} ]]; then
    echo "ERROR State file missing - have you run init? - ${base_name}"
  fi
  cp /statefiles/${base_name} ${t}
done

exit 0
