#!/bin/bash

# shellcheck disable=0

. lib/env.sh

log "check_environment"

# Check dependencies
[ -x "${alfred_workflow_cache}/bw" ] || ./bin/install_dependency.sh "Bitwarden CLI" "bitwarden-cli" "bw"
[ -x "${alfred_workflow_cache}/jq" ] || [ -x "/usr/bin/jq" ] || ./bin/install_dependency.sh "JQ" "jq" "jq"

# Check sync agent
. ./bin/install_sync_agent.sh

# Pass input as output
echo -n "${*}"
