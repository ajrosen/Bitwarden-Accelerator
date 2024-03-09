#!/bin/bash

# shellcheck disable=2154

log "set_organization ${organizationId} ${organizationName}"

echo -n "${organizationId}" > "${alfred_workflow_cache}"/organization_id
echo -n "${organizationName}" > "${alfred_workflow_cache}"/organization_name

# Reset collection
echo -n "" > "${alfred_workflow_cache}"/collection_id
echo -n "" > "${alfred_workflow_cache}"/collection_name
