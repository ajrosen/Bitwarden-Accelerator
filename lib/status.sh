##################################################
# Load saved status

# shellcheck disable=2155,2181

# Check for missing or empty status file
if [ ! -s "${STATUS_FILE}" ]; then
    # Tell main.sh the server is not running
    export BW_SERVER="null"
fi

if [ "${STATE}" == "" ]; then
    curl -s "${API}"/status | jq .data.template > "${STATUS_FILE}"
    export SYNC=$(jq -r '.lastSync // "1970-01-01T00:00:00.000Z" | "\(.[0:19])Z" | fromdate | strflocaltime("%c %Z")' "${STATUS_FILE}")
    export STATE=$(jq -r '.status' "${STATUS_FILE}")
    export USER=$(jq -r '.userEmail' "${STATUS_FILE}")
fi
