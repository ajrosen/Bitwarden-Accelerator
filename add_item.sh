#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

# Get name
URL=$(osascript -e 'return text returned of (display dialog "Enter name of new item" buttons {"OK","Cancel"} with icon stop with title "Add item" default button "OK" default answer "'"${browserURL}"'")')

[ "${URL}" == "" ] && exit

# Get username
SITE=$(echo "${URL}" | cut -d/ -f3)

USERNAME=$(osascript -e 'return text returned of (display dialog "Enter username for '"${SITE}"'" buttons {"OK","Cancel"} with icon stop with title "Add item" default button "OK" default answer "'"${bwuser}"'")')

[ "${USERNAME}" == "" ] && exit

# Get password
PASSWORD=$(curl -s 'localhost:8087/generate?length=20&uppercase&lowercase&number&special' | jq -r .data.data)

PASSWORD=$(osascript -e 'return text returned of (display dialog "Enter password for '"${USERNAME}"'" buttons {"OK","Cancel"} with icon stop with title "Add item" with hidden answer default button "OK" default answer "'"${PASSWORD}"'")')

[ "${PASSWORD}" == "" ] && exit

# Build payload
PAYLOAD='{'
PAYLOAD+='"type": 1'
PAYLOAD+=', "name": "'"${SITE}"'"'
PAYLOAD+=', "organizationId": "'"${ORGANIZATION_ID}"'"'
# PAYLOAD+=', "collectionIds": ['
# [ "${COLLECTION_ID}" == "" ] || PAYLOAD+='"'"${COLLECTION_ID}"'"'
# PAYLOAD+=']'
# [ "${COLLECTION_ID}" == "" ] || PAYLOAD+=', "collectionIds": [ "'"${COLLECTION_ID}"'" ]'
PAYLOAD+=', "login": {'
PAYLOAD+='    "username": "'"${USERNAME}"'"'
PAYLOAD+=',   "password": "'"${PASSWORD}"'"'
PAYLOAD+=',   "uris": ['
PAYLOAD+='        { "match": null, "uri": "'"${URL}"'" }'
PAYLOAD+='    ]'
PAYLOAD+='  }'
PAYLOAD+='}'

echo "${PAYLOAD}" > /tmp/payload.json

# Add item
# curl -s -H 'Content-Type: application/json' -d "${PAYLOAD}" "${API}"/object/item # | jq -r .success
# saveSync
