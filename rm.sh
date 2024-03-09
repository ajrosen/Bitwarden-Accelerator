#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

log "rm ${id} ${name}"

curl -s -X DELETE "${API}"/object/item/"${id}" > /dev/null
saveSync

echo "${name}"
