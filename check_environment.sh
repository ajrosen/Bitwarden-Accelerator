#!/bin/bash

. lib/env.sh

# Check dependencies
[ -x "${alfred_workflow_cache}/bw" ] || ./install.sh "Bitwarden CLI" "bitwarden-cli" "bw"
[ -x "${alfred_workflow_cache}/jq" ] || ./install.sh "JQ" "jq" "jq"

echo -n "${*}"
