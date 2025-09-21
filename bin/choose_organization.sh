#!/bin/bash

. lib/env.sh

log "choose_organization"

echo '{ "items":'

jq \
    -L jq \
    --arg search "" \
    --arg previousMenu "More Actions" \
    -r -f jq/list_organizations.jq \
    "${DATA_DIR}"/organizations \
    | jq '[ { "title": "Choose vault", "valid": "false" } ] + [ .[] | select(.title != "All Vaults") | select(.title != "My Vault") | select(.title != "'"${organization}"'") ]'

echo '}'
