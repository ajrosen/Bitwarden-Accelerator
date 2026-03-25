#!/bin/bash

# shellcheck disable=1091,2154

if [ "${archived}" == "Unarchive" ]; then
    . bin/restore_item.sh
    exit
fi

. lib/env.sh

log "archive ${id} ${name}"

URL="${API}"/object/item/"${id}"

curl -s "${URL}" \
    | jq '.data | . + { archivedDate: (now | todate) }' \
    | curl -s -H 'Content-Type: application/json' -T - "${URL}" \
    > /dev/null

saveSync

echo -n "${name}"
