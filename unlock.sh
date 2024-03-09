#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

log "unlock"

curl -s -d "password=${*}" "${API}"/unlock | jq -r '.message // .data.title'
