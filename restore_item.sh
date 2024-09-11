#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

log "restore ${id} ${name}"

curl -s -X POST "${API}"/restore/item/"${id}" > /dev/null
saveSync

echo -n "${name}"
