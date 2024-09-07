#!/bin/bash

# shellcheck disable=2154,2317

. lib/env.sh

log "set_organization ${objectId} ${organizationId}"

URL="${API}"/object/item

FIELDS="type, name, organizationId, login, notes, favorite, fields, reprompt"

# Get existing item
ITEM=$(curl -s "${URL}/${objectId}" | jq -r '.data | { '"${FIELDS}"' }')

oldId=$(jq -r '.organizationId // ""' <<< "${ITEM}")

if [ "${oldId}" == "${organizationId}" ]; then
    echo -n "Cannot move item to same vault"
    exit
fi

# Add new item
if [ "${organizationId}" == "" ]; then
    PAYLOAD=$(jq -r '.ogranizationId |= null' <<< "${ITEM}")
else
    PAYLOAD=$(jq -r '.organizationId |= "'"${organizationId}"'"' <<< "${ITEM}")
fi

log "${PAYLOAD}"

ITEM=$(curl -s -H 'Content-Type: application/json' -d "${PAYLOAD}" "${URL}")
S=$(jq -r '.success' <<< "${ITEM}")

if [ "${S}" != "true" ]; then
    echo -n "Failed to copy ${name}"

    exit
fi

echo -n "Success: ${S}"
saveSync

exit

# Replace ".collectionIds: null" with ".collectionIds: []"
newId=$(jq -r '.data.id' <<< "${ITEM}")

S=$(curl -s "${URL}/${newId}" \
	| jq '.data | . + { .collectionIds: [] }' \
	| curl -s -H 'Content-Type: application/json' -T - "${URL}/${newId}")
S=$(jq -r '.success' <<< "${ITEM}")

if [ "${S}" != "true" ]; then
    echo -n "Failed to set collections for ${name}"

    exit
fi

sleep 5

# Delete original
# curl -s -X DELETE "${URL}/${objectId}"

saveSync
