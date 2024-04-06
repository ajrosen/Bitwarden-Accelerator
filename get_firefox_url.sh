#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

# Look for workflow
AF=$(echo ../*/alfred-firefox)
[ "${AF}" == "../*/alfred-firefox" ] && exit 0

TAB_INFO=$(${AF} tab-info)

log "Firefox ${TAB_INFO}"

jq -r .alfredworkflow.variables.FF_URL <<< "${TAB_INFO}"
