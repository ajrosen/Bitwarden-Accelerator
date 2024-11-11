#!/bin/bash

# shellcheck disable=1090,2154

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
    log "folderId = ${folderId}, organizationId = ${ORGANIZATION_ID}, collectionId = ${COLLECTION_ID}"

    jq \
	-L jq \
	--rawfile {,"${DATA_DIR}"/}organizations \
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
	"${DATA_DIR}"/items 2>>"${LOG_FILE}"
}

# Refresh lists
if [ $# == 0 ]; then
    [ "$(find "${SYNC_FILE}" "${DATA_DIR}" -size 0)" != "" ] && LAST_SYNC=0

    [ $((NOW - LAST_SYNC)) -gt $((SyncTime * 60)) ] && saveSync
fi

mkdir -p "${RESULTS_DIR}"

# Get most recent item
getSelection
if [ $((NOW - LAST_FETCH)) -lt "${AUTO_ROTATE}" ] && [ "${old_objectId}" != "" ]; then
    log "Recent item: ${old_title} - ${old_objectId} - ${old_subtitle}"

    q "${*}" "./icons/Clock.png" "${old_objectId}" >> "${RESULTS_DIR}"/1
else
    old_objectId=""
fi

# Get browser matches
if [ $# == 0 ] && [ "${browserURL}" != "" ]; then
    log "Browser ${browserURL}"

    URL=$(echo "${browserURL}" | awk 'BEGIN { FS="/" } { h = $3 } END { FS="." ;  $0 = h ; print $(NF-1) "." $NF }')

    q "${URL}" "./icons/${focusedapp}.png" "" "${old_objectId}">> "${RESULTS_DIR}"/2
fi

# List items
q "${*}" "" "" "${old_objectId}" >> "${RESULTS_DIR}"/3

# Check for empty list
S=$(find "${RESULTS_DIR}"/? -size +10c | wc -l)
if [[ "${S}" =~ "0" ]]; then
    echo '[ { "title": "No items found", "arg": "", "valid": false,'
    mods "" false
    echo '} ]'
else
    jq -s flatten "${RESULTS_DIR}"/?
fi
