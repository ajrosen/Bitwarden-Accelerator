#!/bin/bash

# shellcheck disable=1090,2154

. lib/env.sh
. lib/utils.sh

# Load old settings
getSelection

# Check
if [ $((NOW - LAST_FETCH)) -lt "${AUTO_ROTATE}" ] && [ "${objectId}" == "${old_objectId}" ]; then
    if [ "${type}" == 1 ]; then
	if [ "${old_field}" == "Password" ]; then
	    log "Rotate Password -> TOTP"

	    field="TOTP"
	fi
    fi
fi

# Save new settings
saveSelection

echo "${field}"
