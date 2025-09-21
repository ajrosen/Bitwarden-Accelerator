#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

log "set_favorite ${id}"

URL="${API}"/object/item/"${id}"

curl -s "${URL}" \
    | jq '.data | .favorite |= not' \
    | curl -s -H 'Content-Type: application/json' -T - "${URL}" > /dev/null

saveSync

echo -n "${name}"
