#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

log "set_collection ${COLLECTION_ID} ${collectionName}"

echo -n "${COLLECTION_ID}" > "${alfred_workflow_cache}"/collection_id
echo -n "${collectionName}" > "${alfred_workflow_cache}"/collection_name
