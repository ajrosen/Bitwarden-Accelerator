#!/bin/bash

# shellcheck disable=2012,2154

. lib/env.sh
. lib/status.sh
. lib/utils.sh

[ $# == 0 ] && checkTimeout

if [ "${STATE}" != "unlocked" ]; then
    . bin/main.sh
    exit
fi

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
S=$(ls -n "${RESULTS_DIR}/1" | awk '{ print $5 }')
if [ "${S}" -lt 10  ]; then
    echo '[ { "title": "No items in trash", "arg": "", "valid": false,'
    mods "" false
    echo '} ]'
else
    echo '[ { "title": "Select an item to restore from trash", "arg": "return" } ]' \
	 > "${RESULTS_DIR}"/0
    jq -s flatten "${RESULTS_DIR}"/?
fi

echo '}'
