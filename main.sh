#!/bin/bash

# shellcheck disable=2086,2154

. lib/env.sh
. lib/status.sh

echo '{ "items": [ {}'

if [ "${STATE}" == "unauthenticated" ]; then
    # Unauthenticated
    item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}"

elif [ "${BW_SERVER}" == "null" ]; then
    # Server not running
    item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}"

elif [ "${STATE}" == "locked" ]; then
    # Locked
    item "Unlock vault" "unlock" "Logged in as ${bwuser}"
    item "Logout of Bitwarden" "logout"

elif [ "${STATE}" != "unlocked" ]; then
    # Unknown
    item "Bitwarden Error" "" "Unknown state: ${STATE}"

else
    # Unlocked
    organization=${ORGANIZATION_NAME:-"All Vaults"}
    collection=${COLLECTION_NAME:-"All Collections"}

    item "Search Vault" "search"
    item "Search Folders" "folder"
    item "Lock Vault" "lock" "Logged in as ${bwuser}"
    item "Set Default Vault" "organization" "${organization}"
    item "Set Default Collection" "collection" "${collection}"
    item "Sync Vault" "sync" "${SYNC}"
    item "Logout of Bitwarden" "logout"
fi

# Actions available regardless of state
item "Configure Workflow" "workflow" "Opens in Alfred Preferences"

echo '] }'
