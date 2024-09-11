#!/bin/bash

# shellcheck disable=2154

. lib/env.sh
. lib/utils.sh

function clean() {
    find "${RESULTS_DIR}" -type f -delete
}

trap clean EXIT

function q() {
    SEARCH="${1}"
    ICON="${2}"
    RECENT="${3}"
    SKIP="${4}"

    log "SEARCH = ${1}, ICON = ${2}, SKIP = ${3}"

    jq \
	-L jq \
	--rawfile {,"${DATA_DIR}/"}organizations \
	--rawfile {,"${DATA_DIR}"/}collections \
	--rawfile {,"${DATA_DIR}"/}folders \
	--arg folderId "${folderId}" \
	--arg organizationId "${ORGANIZATION_ID}" \
	--arg collectionId "${COLLECTION_ID}" \
	--arg search "${SEARCH}" \
	--arg icon "${ICON}" \
	--arg recent "${RECENT}" \
	--arg skip "${SKIP}" \
	-r -f jq/list_items.jq \
	"${DATA_DIR}"/trash
}

# Refresh lists
if [ $# == 0 ]; then
    [ "$(find "${SYNC_FILE}" "${DATA_DIR}" -size 0)" != "" ] && LAST_SYNC=0

    [ $((NOW - LAST_SYNC)) -gt $((SyncTime * 60)) ] && saveSync
fi

mkdir -p "${RESULTS_DIR}"

# List items
q "${*}" > "${RESULTS_DIR}"/1
echo '{ "items": '

# Check for empty list
if [ -s "${RESULTS_DIR}"/1 ]; then
    echo '[ { "title": "Select an item to restore from trash", "arg": "" } ]' \
	 > "${RESULTS_DIR}"/0
    jq -s flatten "${RESULTS_DIR}"/?
else    
    echo '[ { "title": "No items in trash", "arg": "" } ]'
fi
echo '}'
