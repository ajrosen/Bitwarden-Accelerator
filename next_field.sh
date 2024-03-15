#!/bin/bash

# shellcheck disable=1090,2154

. lib/env.sh

AUTO_ROTATE=${AUTO_ROTATE:-15}

FETCH_FILE="${alfred_workflow_cache}"/last_item

# Load old settings
if [ -f "${FETCH_FILE}" ]; then
    . "${FETCH_FILE}"
else
    LAST_FETCH=0
fi

# Check
if [ $((NOW - LAST_FETCH)) -lt "${AUTO_ROTATE}" ] && [ "${objectId}" == "${old_objectId}" ]; then
    if [ "${type}" == 1 ]; then
	[ "${old_field}" == "Password" ] && field="TOTP"
    fi
fi

# Save new settings
cat > "${FETCH_FILE}" << EOF
LAST_FETCH=${NOW}
old_objectId=${objectId}
old_field=${field}
old_type=${type}
EOF

echo "${field}"
