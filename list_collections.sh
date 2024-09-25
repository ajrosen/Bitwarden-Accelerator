#!/bin/bash

. lib/env.sh

log "list_collections"

echo '{ "items":'

jq \
    -L jq \
    --arg organizationId "${ORGANIZATION_ID}" \
    --arg search "$*" \
    -r -f jq/list_collections.jq \
    "${DATA_DIR}"/collections 2>>"${LOG_FILE}"

echo '}'
