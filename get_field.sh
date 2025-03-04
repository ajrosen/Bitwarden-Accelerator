#!/bin/bash

# shellcheck disable=1090,2154

. lib/env.sh
. lib/utils.sh

# Save item
saveSelection

# There is no API to get an SSH private key, so we have to get the
# whole item and pick out the value we want (the private key)
if [ "${field}" == "ssh" ]; then
    field="item"
    KEY=".data.sshKey.privateKey"
else
    KEY=".data.data"
fi

log "${API}/object/${field}/${id}"

OBJ=$(curl -s "${API}"/object/"${field}"/"${id}")

if [ "$(jq -j .success <<< "${OBJ}")" == "true" ]; then
    jq -j "${KEY}" <<< "${OBJ}"
else
    jq -j .message <<< "${OBJ}"
    exit 1
fi
