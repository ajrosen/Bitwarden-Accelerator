#!/bin/bash

# shellcheck disable=1090,2154

. lib/env.sh
. lib/utils.sh

# Save item
saveSelection

log "${API}/object/${field}/${id}"

OBJ=$(curl -s "${API}"/object/"${field}"/"${id}")

if [ "$(jq -r .success <<< "${OBJ}")" == "true" ]; then
    jq -r .data.data <<< "${OBJ}"
else
    jq -r .message <<< "${OBJ}"
    exit 1
fi
