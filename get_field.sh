#!/bin/bash

# shellcheck disable=1090,2154

. lib/env.sh
. lib/utils.sh

# Save item
saveSelection

log "${API}/object/${field}/${id}"

OBJ=$(curl -s "${API}"/object/"${field}"/"${id}")

if [ "$(jq -j .success <<< "${OBJ}")" == "true" ]; then
    jq -j .data.data <<< "${OBJ}"
else
    jq -j .message <<< "${OBJ}"
    exit 1
fi
