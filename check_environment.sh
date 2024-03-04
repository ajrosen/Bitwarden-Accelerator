#!/bin/bash

# shellcheck disable=1091,2154,2181

. lib/env.sh

# Check dependencies
[ -x "${alfred_workflow_cache}/bw" ] || ./install_dependency.sh "Bitwarden CLI" "bitwarden-cli" "bw"
[ -x "${alfred_workflow_cache}/jq" ] || ./install_dependency.sh "JQ" "jq" "jq"

# Get current settings
cat > "${alfred_workflow_data}"/bw.vars  << EOF
old_SyncTime=${SyncTime}
old_autoSync=${autoSync}
EOF

# Load old settings
[ -f "${alfred_workflow_data}"/bw.vars.old ] || mv -f "${alfred_workflow_data}"/bw.vars "${alfred_workflow_data}"/bw.vars.old
. "${alfred_workflow_data}"/bw.vars.old

# Check changes to sync agent
if [ "${autoSync}" != "${old_autoSync}" ] || [ "${SyncTime}" != "${old_SyncTime}" ]; then
    . ./install_sync_agent.sh
fi

# Save current settings
mv -f "${alfred_workflow_data}"/bw.vars "${alfred_workflow_data}"/bw.vars.old

# Pass input as output
echo -n "${*}"
