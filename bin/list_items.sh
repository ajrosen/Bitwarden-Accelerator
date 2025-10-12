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

    log "SEARCH = ${1}, ICON = ${2}, RECENT = ${3}, SKIP = ${4}"
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

    # Maybe fetch favicons
    if [ "${favicons}" != "None" ] && [ ! -d "${FAVICONS_DIR}" ]; then
	log "Fetching icons"
	./bin/get_favicons.rb fetch &>/dev/null & disown
    fi
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

    # Assume browserURL starts with scheme://
    URL=$(echo "${browserURL}" \
	      | cut -d/ -f3 \
	      | cut -d: -f1 \
	      | awk -F . '{if (NF>1) {printf("%s.", $(NF-1))} printf("%s", $NF)}')

    # Filter search by URIs matching ${URL}
    q "${URL}" "./icons/${focusedapp}.png" "" "${old_objectId}" \
      | jq '.[] | [ select(.variables.uris[] | test("'"${URL}"'"; "i")) ] | unique_by(.id)' \
	   >> "${RESULTS_DIR}"/2
fi

# List items
q "${*}" "" "" "${old_objectId}" >> "${RESULTS_DIR}"/3

# Make sure missing icons use the default
if [ $# == 0 ] && [ "${favicons}" != "None" ]; then
    ./bin/get_favicons.rb symlink
fi

# Check for empty list
S=$(find "${RESULTS_DIR}"/? -size +10c | wc -l)
if [[ "${S}" =~ "0" ]]; then
    echo '[ { "title": "No items found", "arg": "", "valid": false,'
    mods "" false
    echo '} ]'
else
    jq -s flatten "${RESULTS_DIR}"/?
fi
