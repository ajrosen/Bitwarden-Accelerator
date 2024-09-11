#!/bin/bash

# shellcheck disable=2059

# Look for workflow
AF=$(echo ../*/alfred-firefox)
[ "${AF}" == "2>&- ../*/alfred-firefox" ] && exit 0

TAB_INFO=$(${AF} tab-info)

jq -j .alfredworkflow.variables.FF_URL <<< "${TAB_INFO}"
