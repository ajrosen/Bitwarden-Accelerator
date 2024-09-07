##################################################
# Load saved status

# shellcheck disable=2155,2181

# If we have arguments then we've already checked status
[ $# == 0 ] && curl -s "${API}"/status | jq .data.template > "${STATUS_FILE}"

if [ ! -s "${STATUS_FILE}" ]; then
    export BW_SERVER="null"
    return
fi

export SYNC=$(jq -r '.lastSync // "1970-01-01T00:00:00.000Z" | "\(.[0:19])Z" | fromdate | strflocaltime("%c %Z")' "${STATUS_FILE}")
export STATE=$(jq -r '.status' "${STATUS_FILE}")
export USER=$(jq -r '.userEmail' "${STATUS_FILE}")
