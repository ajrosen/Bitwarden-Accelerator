##################################################
# Initialize workflow environment

# shellcheck disable=1090,2034,2154,2155

NOW=$(date +%s)

# Workflow
alfred_workflow_cache=${alfred_workflow_cache:-"."}
export PATH="${alfred_workflow_cache}":${PATH}
LOG_FILE="${alfred_workflow_cache}"/"${alfred_workflow_bundleid}".log

SyncTime=${SyncTime:-30}

# Bitwarden server
bwhost=${bwhost:-localhost}
bwport=${bwport:-8087}

export API=http://"${bwhost}":"${bwport}"
export bwuser=${bwuser:-user@example.com}

# Caching
AUTO_ROTATE=${SyncTime}
DATA_DIR="${alfred_workflow_cache}"/data
FETCH_FILE="${alfred_workflow_cache}"/last_item
RESULTS_DIR="${alfred_workflow_cache}"/results
STATUS_FILE="${alfred_workflow_cache}"/status
SYNC_FILE="${alfred_workflow_cache}"/sync
TIMER_FILE="${alfred_workflow_cache}"/timer

# Check workflow version
touch "${alfred_workflow_cache}"/version
VERSION=$(cat "${alfred_workflow_cache}"/version)
if [ "${VERSION}" != "${alfred_workflow_version}" ]; then
    echo "${alfred_workflow_version}" > "${alfred_workflow_cache}"/version

    # Set default organization and collection
    echo '' > "${alfred_workflow_cache}"/collection_id
    echo '' > "${alfred_workflow_cache}"/collection_name

    echo '0' > "${alfred_workflow_cache}"/organization_id
    echo 'All Vaults' > "${alfred_workflow_cache}"/organization_name
fi

ORGANIZATION_ID="${ORGANIZATION_ID:-$(cat "${alfred_workflow_cache}"/organization_id)}"
ORGANIZATION_NAME="$(cat "${alfred_workflow_cache}"/organization_name)"

COLLECTION_ID="${COLLECTION_ID:-$(cat "${alfred_workflow_cache}"/collection_id)}"
COLLECTION_NAME="$(cat "${alfred_workflow_cache}"/collection_name)"

LAST_SYNC=0
[ -f "${SYNC_FILE}" ] && LAST_SYNC="$(cat "${SYNC_FILE}")"

# Helper functions
cacheVault() {
    OBJECTS="items folders collections organizations"

    mkdir -p "${DATA_DIR}"

    for OBJECT in ${OBJECTS}; do
	curl -s "${API}"/list/object/"${OBJECT}" \
	     | jq -L jq -r -f jq/clean.jq \
	     > "${DATA_DIR}"/"${OBJECT}"
    done

    curl -s "${API}"/list/object/items?trash \
	 --connect-timeout 3 \
	 --max-time 5 \
	| jq -L jq -r -f jq/clean.jq \
	     > "${DATA_DIR}"/trash
}

saveSync() {
    curl -s -X POST "${API}"/sync > /dev/null
    date +%s > "${SYNC_FILE}"

    cacheVault
}

log() {
    [ "${DEBUG}" != 1 ] && return

    echo "$(date): [$(basename "${BASH_SOURCE[1]}"):${BASH_LINENO[0]}] ${*}" >> "${LOG_FILE}"
}

curl() {
    /usr/bin/curl --connect-timeout 3 --max-time 5 "${@}"
}
