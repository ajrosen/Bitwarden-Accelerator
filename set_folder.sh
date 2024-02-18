#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

URL="${API}"/object/item/"${objectId}"

curl -s "${URL}" \
    | jq '.data | .folderId |= "'"${folderId}"'"' \
    | curl -s -H 'Content-Type: application/json' -T - "${URL}" > /dev/null

saveSync
