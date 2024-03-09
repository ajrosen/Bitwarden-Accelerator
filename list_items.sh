#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

function clean() {
    find "${RESULTS_DIR}" -type f -delete
}

trap clean EXIT

# Refresh lists
if [ $# == 0 ]; then
    [ "$(find "${SYNC_FILE}" "${DATA_DIR}" -size 0)" != "" ] && LAST_SYNC=0

    NOW=$(date +%s)
    [ $((NOW - LAST_SYNC)) -gt $((SyncTime * 60)) ] && saveSync
fi

mkdir -p "${RESULTS_DIR}"

# Get browser matches
if [ $# == 0 ] && [ "${browserURL}" != "" ]; then
    log "browser ${browserURL}"

    URL=$(echo "${browserURL}" | awk 'BEGIN { FS="/" } { h = $3 } END { FS="." ;  $0 = h ; print $(NF-1) "." $NF }')

    jq \
	-L jq \
	--rawfile {,"${DATA_DIR}/"}organizations \
	--rawfile {,"${DATA_DIR}"/}collections \
	--rawfile {,"${DATA_DIR}"/}folders \
	--arg folderId "${folderId}" \
	--arg organizationId "${ORGANIZATION_ID}" \
	--arg collectionId "${COLLECTION_ID}" \
	--arg search "${URL}" \
	--arg icon "./icons/${focusedapp}.png" \
	-r -f jq/list_items.jq \
	"${DATA_DIR}"/items >> "${RESULTS_DIR}"/1
fi

# List items
jq \
    -L jq \
    --rawfile {,"${DATA_DIR}/"}organizations \
    --rawfile {,"${DATA_DIR}"/}collections \
    --rawfile {,"${DATA_DIR}"/}folders \
    --arg folderId "${folderId}" \
    --arg organizationId "${ORGANIZATION_ID}" \
    --arg collectionId "${COLLECTION_ID}" \
    --arg search "${*}" \
    --arg icon "" \
    -r -f jq/list_items.jq \
    "${DATA_DIR}"/items >> "${RESULTS_DIR}"/2

jq -s flatten "${RESULTS_DIR}"/?
