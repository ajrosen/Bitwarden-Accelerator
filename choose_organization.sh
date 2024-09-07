#!/bin/bash

. lib/env.sh

log "choose_organization"

echo '{ "items":'

jq \
    -L jq \
    --arg search "" \
    -r -f jq/list_organizations.jq \
    "${DATA_DIR}"/organizations \
    | jq '[ .[] | select(.variables) ]'

echo '}'
