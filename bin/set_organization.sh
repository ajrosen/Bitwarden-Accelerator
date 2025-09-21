#!/bin/bash

# shellcheck disable=2154,2317

. lib/env.sh

log "set_organization ${objectId} ${organizationId} ${collectionId}"

URL="${API}"/object/item/"${objectId}"

ITEM=$(curl -s "${URL}")

FILTER='.organizationId |= "'"${organizationId}"'"'
FILTER+=' | .collectionIds |= [ "'"${collectionId}"'" ]'

# Build payload
PAYLOAD=$(jq -r ".data | ${FILTER}" <<< "${ITEM}")

# Copy item to organization
R=$(curl -s -H 'Content-Type: application/json' -d "${PAYLOAD}" "${API}"/object/item)

S=$(jq -r .success <<< "${R}")

if [ "${S}" == "true" ]; then
    # Delete original
    curl -s -X DELETE "${URL}/${ID}" | jq -j .success
    saveSync
else
    echo "${S}"
fi
