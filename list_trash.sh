#!/bin/bash

# shellcheck disable=2154

. lib/env.sh
. lib/utils.sh

TRASH="${RESULTS_DIR}/trash"

function clean() {
    rm -f "${TRASH}"
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
q "${*}" > "${TRASH}"
echo '{ "items": '

# Check for empty list
# S=$(find "${TRASH}" -size +10c | wc -l)
# if [[ "${S}" =~ "0" ]]; then
#     echo '[ { "title": "No items found", "arg": "" } ]'
# else
    jq -s flatten "${TRASH}"
# fi
echo '}'
