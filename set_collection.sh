#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

log "set_collection ${collectionId} ${collectionName}"

echo -n "${collectionId}" > "${alfred_workflow_cache}"/collection_id
echo -n "${collectionName}" > "${alfred_workflow_cache}"/collection_name
