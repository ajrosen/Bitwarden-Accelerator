#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

log "add_item"

URL=$(jq -j .url <<< "${*}")
SITE=$(cut -d/ -f3 <<< "${URL}")

P='return text returned of (display dialog'
Q='return (display dialog'
I='with icon caution'
T='with title "Add item"'

# Get name
CMD="${P} \"Enter name of new item\" ${I} ${T} default answer \"${SITE}\")"
NAME=$(2>&- osascript -e "${CMD}")

[ "${NAME}" == "" ] && exit

# Get username
SITE=$(cut -d/ -f3 <<< "${NAME}")
CMD="${P} \"Enter username for ${SITE}\" ${I} ${T} default answer \"${bwuser}\")"
USERNAME=$(2>&- osascript -e "${CMD}")

[ "${USERNAME}" == "" ] && exit

# Get password
GENERATED="$(./bin/generate_password.sh)"
CMD="${Q} \"Enter password for ${USERNAME}\" ${I} ${T} default answer \"${GENERATED}\" with hidden answer"
CMD+=' buttons { "Cancel", "OK", "Copy to Clipboard" } default button "Copy to Clipboard")'

J=$(2>&- osascript -s s -e "${CMD}" | sed 's/^{button returned/{"button"/;s/", text returned:/", "text":/')
BUTTON=$(jq -j .button <<< "${J}")
PASSWORD=$(jq -j .text <<< "${J}")

[ "${PASSWORD}" == "" ] && exit

if [ "${PASSWORD}" != "${GENERATED}" ]; then
    # Confirm password
    CMD="${Q} \"Confirm password for ${USERNAME}\" ${I} ${T} default answer \"\" with hidden answer"
    CMD+=' buttons { "Cancel", "OK", "Copy to Clipboard" } default button "Copy to Clipboard")'

    J=$(2>&- osascript -s s -e "${CMD}" | sed 's/^{button returned/{"button"/;s/", text returned:/", "text":/')
    BUTTON=$(jq -j .button <<< "${J}")
    CONFIRM=$(jq -j .text <<< "${J}")

    [ "${CONFIRM}" == "" ] && exit

    if [ "${CONFIRM}" != "${PASSWORD}" ]; then
	echo -n "Add item ${SITE//,/ },Passwords do not match,"
	exit
    fi
fi

[ "${PASSWORD}" == "" ] && exit

# Build payload
PAYLOAD='{ "type": 1, "name": "'"${SITE}"'"'
[ "${#ORGANIZATION_ID}" -gt 1 ] && PAYLOAD+=',"organizationId": "'"${ORGANIZATION_ID}"'"'
PAYLOAD+=',"login": {'
PAYLOAD+=' "username": "'"${USERNAME}"'"'
PAYLOAD+=',"password": "'"${PASSWORD}"'"'
PAYLOAD+=',"uris": [ { "match": null, "uri": "'"${URL}"'" } ]'
PAYLOAD+='} }'

# Add item
S=$(curl -s -H 'Content-Type: application/json' -d "${PAYLOAD}" "${API}"/object/item | jq -j .success)

[ "${BUTTON}" == "Copy to Clipboard" ] && CLIPBOARD="${PASSWORD}"
echo -n "Added ${SITE//,/ },Success: ${S},${CLIPBOARD}"
