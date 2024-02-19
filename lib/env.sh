##################################################
# Initialize workflow environment

# shellcheck disable=2034,2155

# Workflow
alfred_workflow_cache=${alfred_workflow_cache:-"."}
export PATH="${alfred_workflow_cache}":${PATH}

SyncTime=${SyncTime:-30}

# Bitwarden server
bwhost=${bwhost:-localhost}
bwport=${bwport:-8087}

export API=http://"${bwhost}":"${bwport}"
export bwuser=${bwuser:-user@example.com}

# Caching
STATUS_FILE="${alfred_workflow_cache}"/status
SYNC_FILE="${alfred_workflow_cache}"/sync
DATA_DIR="${alfred_workflow_cache}"/data
RESULTS_DIR="${alfred_workflow_cache}"/results

touch "${alfred_workflow_cache}"/collection_id
touch "${alfred_workflow_cache}"/collection_name

touch "${alfred_workflow_cache}"/organization_id
touch "${alfred_workflow_cache}"/organization_name

COLLECTION_ID="$(cat "${alfred_workflow_cache}"/collection_id)"
COLLECTION_NAME="$(cat "${alfred_workflow_cache}"/collection_name)"

ORGANIZATION_ID="$(cat "${alfred_workflow_cache}"/organization_id)"
ORGANIZATION_NAME="$(cat "${alfred_workflow_cache}"/organization_name)"

LAST_SYNC="$(cat "${SYNC_FILE}")"

# Helper functions
cacheVault() {
    OBJECTS="items folders collections organizations"

    mkdir -p "${DATA_DIR}"

    for OBJECT in ${OBJECTS}; do
	curl -s "${API}"/list/object/"${OBJECT}" \
	     | jq -L .jq -r -f .jq/clean.jq \
	     > "${DATA_DIR}"/"${OBJECT}"
    done
}

saveSync() {
    curl -s -X POST "${API}"/sync > /dev/null
    date +%s > "${SYNC_FILE}"

    cacheVault
}

item() {
    echo ', {'
    echo '  "title": "'"${1}"'"'
    echo ', "arg": "'"${2}"'"'
    echo ', "subtitle": "'"${3}"'"'
    mods "${3}"
    echo '}'
}

mods() {
    echo ', "mods": {'
    for mod in "cmd" "alt" "control" "shift" "function"; do
	echo '"'"${mod}"'": { "valid": "true", "subtitle": "'"${1}"'" }, '
    done
    echo '}'
}
