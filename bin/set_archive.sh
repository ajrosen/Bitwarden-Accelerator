#!/bin/bash

# shellcheck disable=1091,2154

if [ "${archived}" == "Unarchive" ]; then
    . bin/restore_item.sh
    exit
fi

. lib/env.sh

log "archive ${id} ${name}"

curl -s "${API}"/object/item/"${id}" \
    | jq '.data | . + { archivedDate: (now | todate) }' \
    | curl -s -H 'Content-Type: application/json' -T - "${URL}" \
    | jq .success

saveSync

echo -n "${name}"
