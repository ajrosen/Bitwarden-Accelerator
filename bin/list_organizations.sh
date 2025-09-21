#!/bin/bash

. lib/env.sh

log "list_organizations"

echo '{ "items":'

jq \
    -L jq \
    --arg search "$*" \
    --arg previousMenu "Main" \
    -r -f jq/list_organizations.jq \
    "${DATA_DIR}"/organizations 2>>"${LOG_FILE}"

echo '}'
