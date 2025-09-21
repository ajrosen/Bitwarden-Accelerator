#!/bin/bash

. lib/env.sh

log "choose_collection"

echo '{ "items":'

jq \
    -L jq \
    --arg organizationId "${organizationId}" \
    --arg search "$*" \
    --arg previousMenu "Choose Organization" \
    -r -f jq/list_collections.jq \
    "${DATA_DIR}"/collections \
    | jq '[ { "title": "Choose collection", "valid": "false" } ] + [ .[] | select(.title != "All Collections") ]'

echo '}'
