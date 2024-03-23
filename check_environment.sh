#!/bin/bash

# shellcheck disable=0

. lib/env.sh

# Check dependencies
[ -x "${alfred_workflow_cache}/bw" ] || ./install_dependency.sh "Bitwarden CLI" "bitwarden-cli" "bw"
[ -x "${alfred_workflow_cache}/jq" ] || ./install_dependency.sh "JQ" "jq" "jq"

# Check sync agent
. ./install_sync_agent.sh

# Pass input as output
echo -n "${*}"
