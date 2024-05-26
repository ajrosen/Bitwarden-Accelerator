#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

log "unlock"

p=$(./get_password.applescript "${bwuser}")

[ "${p}" == "" ] && exit

curl -s -d "password=${p}" "${API}"/unlock | jq -r '.message // .data.title'
