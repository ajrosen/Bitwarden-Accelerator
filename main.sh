#!/bin/bash

# shellcheck disable=2154

. lib/env.sh
. lib/status.sh
. lib/utils.sh

[ $# == 0 ] && checkTimeout

echo '{ "items": [ {}'

if [ "${STATE}" == "unauthenticated" ]; then
    log "Unauthenticated"

    # Unauthenticated
    echo ", $(item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}")"

elif [ "${BW_SERVER}" == "null" ]; then
    log "Server not running"

    # Server not running
    echo ", $(item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}")"

elif [ "${STATE}" == "locked" ]; then
    log "Vault locked"

    # Locked
    echo ", $(item "Unlock vault" "unlock" "Logged in as ${bwuser}")"
    echo ", $(item "Logout of Bitwarden" "logout")"

elif [ "${STATE}" != "unlocked" ]; then
    log "Unknown state: ${STATE}"

    # Unknown
    echo ", $(item "Bitwarden Error" "" "Unknown state: ${STATE}")"

else
    # Unlocked
    organization=${ORGANIZATION_NAME:-"All Vaults"}
    collection=${COLLECTION_NAME:-"All Collections"}

    AUTO=( "" " (auto sync $((SyncTime)) minutes)" )

    echo ", $(item "Search Vault" "search" "Search your vault")"
    echo ", $(item "Search Folders" "folder" "Show your folders")"
    echo ", $(item "Add item" "add" "Add a new item to your vault")"
    echo ", $(item "Lock Vault" "lock" "Logged in as ${bwuser}")"
    echo ", $(item "Set Default Vault" "organization" "${organization}")"
    echo ", $(item "Set Default Collection" "collection" "${collection}")"
    echo ", $(item "Sync Vault" "sync" "${SYNC}${AUTO[${autoSync}]}")"
    echo ", $(item "Logout of Bitwarden" "logout" "${serverUrl}")"
fi

# Actions available regardless of state
echo ", $(item "Configure Workflow" "workflow" "Opens in Alfred Preferences (${alfred_workflow_version})")"

echo '] }'
