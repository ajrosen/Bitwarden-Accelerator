#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

rm -f "${alfred_workflow_cache}"/"${alfred_workflow_bundleid}".log

# Look for workflow
AF=$(echo ../*/alfred-firefox)
[ "${AF}" == "../*/alfred-firefox" ] && exit 0

TAB_INFO=$(${AF} tab-info)

jq -r .alfredworkflow.variables.FF_URL <<< "${TAB_INFO}"
