#!/bin/bash

# shellcheck disable=0

. lib/env.sh
. lib/status.sh

echo '{ "items": [ {}'

if [ "${STATE}" == "unauthenticated" ]; then
    log "Unauthenticated"

    # Unauthenticated
    item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}"

elif [ "${BW_SERVER}" == "null" ]; then
    log "Server not running"

    # Server not running
    item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}"

elif [ "${STATE}" == "locked" ]; then
    log "Vault locked"

    # Locked
    item "Unlock vault" "unlock" "Logged in as ${bwuser}"
    item "Logout of Bitwarden" "logout"

elif [ "${STATE}" != "unlocked" ]; then
    log "Unknown state: ${STATE}"

    # Unknown
    item "Bitwarden Error" "" "Unknown state: ${STATE}"

else
    # Unlocked
    organization=${ORGANIZATION_NAME:-"All Vaults"}
    collection=${COLLECTION_NAME:-"All Collections"}

    AUTO=( "" " (auto sync $((SyncTime)) minutes)" )

    item "Search Vault" "search"
    item "Search Folders" "folder"
    item "Lock Vault" "lock" "Logged in as ${bwuser}"
    item "Set Default Vault" "organization" "${organization}"
    item "Set Default Collection" "collection" "${collection}"
    item "Sync Vault" "sync" "${SYNC}${AUTO[${autoSync}]}"
    item "Logout of Bitwarden" "logout" "${serverUrl}"
fi

# Actions available regardless of state
item "Configure Workflow" "workflow" "Opens in Alfred Preferences (${alfred_workflow_version})"

echo '] }'
