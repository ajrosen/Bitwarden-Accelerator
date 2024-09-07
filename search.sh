#!/bin/bash

# shellcheck disable=2068

. lib/env.sh
. lib/status.sh
. lib/utils.sh

[ $# == 0 ] && checkTimeout

echo '{ "items": '

if [ "${STATE}" == "unauthenticated" ]; then
    log "Unauthenticated"

    # Unauthenticated
    echo '[ {}'
    echo ", $(item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}")"
    echo ", $(item "Configure Workflow" "workflow" "Opens in Alfred Preferences")"
    echo ']'

elif [ "${BW_SERVER}" == "null" ]; then
    log "Server not running"

    # Server not running
    echo '[ {}'
    echo ", $(item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}")"
    echo ", $(item "Configure Workflow" "workflow" "Opens in Alfred Preferences")"
    echo ']'

elif [ "${STATE}" == "locked" ]; then
    log "Vault locked"

    # Locked
    echo '[ {}'
    echo ", $(item "Unlock vault" "unlock" "Logged in as ${bwuser}")"
    echo ", $(item "Logout of Bitwarden" "logout")"
    echo ", $(item "Configure Workflow" "workflow" "Opens in Alfred Preferences")"
    echo ']'

elif [ "${STATE}" != "unlocked" ]; then
    log "Unknown state: ${STATE}"

    # Unknown
    echo '[ {}'
    echo ", $(item "Bitwarden Error" "" "Unknown state: ${STATE}")"
    echo ']'

else
    # Unlocked
    ./list_items.sh $@
fi

echo ' }'
