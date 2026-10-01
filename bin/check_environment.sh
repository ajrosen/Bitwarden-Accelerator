#!/bin/bash

# shellcheck disable=1091,2154

. lib/env.sh

log "check_environment"

# BW_PATH ("Bitwarden CLI path" in the workflow configuration) selects a specific
# bw instead of searching the usual locations, e.g. one installed by a version
# manager or pinned to an older release. The link is refreshed on every run so
# changing the setting takes effect immediately.
BW_PATH="${BW_PATH/#\~/${HOME}}"
if [ -n "${BW_PATH}" ]; then
    if [ -x "${BW_PATH}" ]; then
	ln -sf "${BW_PATH}" "${alfred_workflow_cache}/bw"
    else
	log "BW_PATH ${BW_PATH} is not executable, searching the usual locations"
    fi
fi

# Check dependencies
[ -x "${alfred_workflow_cache}/bw" ] || ./bin/install_dependency.sh "Bitwarden CLI" "bitwarden-cli" "bw"
[ -x "${alfred_workflow_cache}/jq" ] || [ -x "/usr/bin/jq" ] || ./bin/install_dependency.sh "JQ" "jq" "jq"

# Check sync agent
. ./bin/install_sync_agent.sh

# Pass input as output
echo -n "${*}"
