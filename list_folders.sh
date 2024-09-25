#!/bin/bash

. lib/env.sh

log "list_folders"

echo '{ "items":'

jq \
    -L jq \
    --arg search "$*" \
    -r -f jq/list_folders.jq \
    "${DATA_DIR}"/folders 2>>"${LOG_FILE}"

echo '}'
