#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

[ "${ORGANIZATION_ID}" == 0 ] && organizationName="All Vaults"
[ "${ORGANIZATION_ID}" == 1 ] && organizationName="My Vault"

log "default_organization ${ORGANIZATION_ID} ${organizationName}"

echo -n "${ORGANIZATION_ID}" > "${alfred_workflow_cache}"/organization_id
echo -n "${organizationName}" > "${alfred_workflow_cache}"/organization_name

# Reset collection
echo -n "" > "${alfred_workflow_cache}"/collection_id
echo -n "" > "${alfred_workflow_cache}"/collection_name
