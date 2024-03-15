#!/bin/bash

# shellcheck disable=1090,2154

. lib/env.sh

# Save item
cat > "${FETCH_FILE}" << EOF
LAST_FETCH=${NOW}
old_objectId=${objectId}
old_field=${field}
old_type=${type}
EOF

log "${API}/object/${field}/${id}"

OBJ=$(curl -s "${API}"/object/"${field}"/"${id}")

if [ "$(jq -r .success <<< "${OBJ}")" == "true" ]; then
    jq -r .data.data <<< "${OBJ}"
else
    jq -r .message <<< "${OBJ}"
    exit 1
fi
