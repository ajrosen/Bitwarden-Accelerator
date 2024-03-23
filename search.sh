#!/bin/bash

# shellcheck disable=2068

. lib/env.sh
. lib/status.sh
. lib/utils.sh

echo '{ "items": '

if [ "${STATE}" == "unauthenticated" ]; then
    log "Unauthenticated"

    # Unauthenticated
    echo '[ {}'
    item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}"
    item "Configure Workflow" "workflow" "Opens in Alfred Preferences"
    echo ']'

elif [ "${BW_SERVER}" == "null" ]; then
    log "Server not running"

    # Server not running
    echo '[ {}'
    item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}"
    item "Configure Workflow" "workflow" "Opens in Alfred Preferences"
    echo ']'

elif [ "${STATE}" == "locked" ]; then
    log "Vault locked"

    # Locked
    echo '[ {}'
    item "Unlock vault" "unlock" "Logged in as ${bwuser}"
    item "Logout of Bitwarden" "logout"
    item "Configure Workflow" "workflow" "Opens in Alfred Preferences"
    echo ']'

elif [ "${STATE}" != "unlocked" ]; then
    log "Unknown state: ${STATE}"

    # Unknown
    echo '[ {}'
    item "Bitwarden Error" "" "Unknown state: ${STATE}"
    echo ']'

else
    # Unlocked
    ./list_items.sh $@
fi

echo ' }'
