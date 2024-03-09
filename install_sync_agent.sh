#!/bin/bash

# shellcheck disable=2154,2181

. lib/env.sh

PLIST="${alfred_workflow_bundleid}".plist

START_INTERVAL=$((SyncTime * 60))

sed "s:WORKFLOW:${alfred_preferences}/${alfred_workflow_uid}:;s:START_INTERVAL:${START_INTERVAL}:" \
    sync_agent.plist.template > ~/Library/LaunchAgents/"${PLIST}"

# Unload launch agent
launchctl unload -F ~/Library/LaunchAgents/"${PLIST}"

# Load launch agent
if [ "${autoSync}" == 1 ]; then
    launchctl load -F ~/Library/LaunchAgents/"${PLIST}"

    NOW=$(date +%s)
    [ $((NOW - LAST_SYNC)) -gt ${START_INTERVAL} ] && launchctl start "${alfred_workflow_bundleid}"
fi
