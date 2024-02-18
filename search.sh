#!/bin/bash

# shellcheck disable=2048,2086

. lib/env.sh
. lib/status.sh

echo '{ "items": '

if [ "${STATE}" == "unauthenticated" ]; then
    # Unauthenticated
    echo '[ {}'
    item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}"
    item "Configure Workflow" "workflow" "Opens in Alfred Preferences"
    echo ']'

elif [ "${BW_SERVER}" == "null" ]; then
    # Server not running
    echo '[ {}'
    item "Login to Bitwarden" "login" "Default ${1:-${bwuser}}"
    item "Configure Workflow" "workflow" "Opens in Alfred Preferences"
    echo ']'

elif [ "${STATE}" == "locked" ]; then
    # Locked
    echo '[ {}'
    item "Unlock vault" "unlock" "Logged in as ${bwuser}"
    item "Logout of Bitwarden" "logout"
    item "Configure Workflow" "workflow" "Opens in Alfred Preferences"
    echo ']'

elif [ "${STATE}" != "unlocked" ]; then
    # Unknown
    echo '[ {}'
    item "Bitwarden Error" "" "Unknown state: ${STATE}"
    echo ']'

else
    # Unlocked
    ./list_items.sh $*
fi

echo ' }'
