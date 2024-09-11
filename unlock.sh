#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

log "unlock"

p=$(2>&- ./get_password.applescript "${bwuser}")

[ "${p}" == "" ] && exit

RESPONSE=$(curl -s -H 'Content-Type: application/json' -d '{"password": "'"${p}"'"}' "${API}"/unlock)

if [ "$(jq -j '.success' <<< "${RESPONSE}")" != "true" ]; then
    RESPONSE=$(curl -s -d "password=${p}" "${API}"/unlock)
fi

jq -j '.message // .data.title' <<< "${RESPONSE}"
