#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

URL=$(echo "${*}" | jq -r .url)
SITE=$(echo "${URL}" | cut -d/ -f3)

P='return text returned of (display dialog'
I='with icon caution'
T='with title "Add item"'

# Get name
CMD="${P} \"Enter name of new item\" ${I} ${T} default answer \"${SITE}\")"
NAME=$(osascript -e "${CMD}")

[ "${NAME}" == "" ] && exit

# Get username
SITE=$(echo "${NAME}" | cut -d/ -f3)

CMD="${P} \"Enter username for ${SITE}\" ${I} ${T} default answer \"${bwuser}\")"
USERNAME=$(osascript -e "${CMD}")

[ "${USERNAME}" == "" ] && exit

# Get password
GENERATED=$(curl -s "${API}/generate?length=20&uppercase&lowercase&number&special" | jq -r .data.data)

CMD="${P} \"Enter password for ${USERNAME}\" ${I} ${T} default answer \"${GENERATED}\" with hidden answer)"
PASSWORD=$(osascript -e "${CMD}")

[ "${PASSWORD}" == "" ] && exit

if [ "${PASSWORD}" != "${GENERATED}" ]; then
    CMD="${P} \"Confirm password for ${USERNAME}\" ${I} ${T} default answer \"\" with hidden answer)"
    CONFIRM=$(osascript -e "${CMD}")

    if [ "${CONFIRM}" != "${PASSWORD}" ]; then
	echo 'Add item,Passwords do not match'
	exit
    fi
fi

[ "${PASSWORD}" == "" ] && exit

# Build payload
PAYLOAD='{ "type": 1, "name": "'"${SITE}"'"'
PAYLOAD+=',"organizationId": '
if [ "${ORGANIZATION_ID}" == "" ]; then
    PAYLOAD+='null'
else
    PAYLOAD+='"'"${ORGANIZATION_ID}"'"'
fi
PAYLOAD+=',"login": {'
PAYLOAD+=' "username": "'"${USERNAME}"'"'
PAYLOAD+=',"password": "'"${PASSWORD}"'"'
PAYLOAD+=',"uris": [ { "match": null, "uri": "'"${URL}"'" }'
PAYLOAD+='] } }'

# Add item
S=$(curl -s -H 'Content-Type: application/json' -d "${PAYLOAD}" "${API}"/object/item | jq -r .success)

echo -n "Added ${SITE//,/ },Success: ${S}"
