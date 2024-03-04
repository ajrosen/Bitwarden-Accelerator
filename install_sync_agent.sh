#!/bin/bash

# shellcheck disable=2154,2181

PLIST="${alfred_workflow_bundleid}".plist

START_INTERVAL=$((SyncTime * 60))

sed "s/BUNDLEID/${alfred_workflow_bundleid}/;s/START_INTERVAL/${START_INTERVAL}/" \
    sync_agent.plist > ~/Library/LaunchAgents/"${PLIST}"

# Unload launch agent
launchctl unload -F ~/Library/LaunchAgents/"${PLIST}"

# Load and start launch agent
if [ "${autoSync}" == 1 ]; then
    launchctl load -F ~/Library/LaunchAgents/"${PLIST}"
    launchctl start "${alfred_workflow_bundleid}"

    osascript -e 'display notification "Started Bitwarden Sync service" with title "'"${alfred_workflow_name}"'"'
fi
