#!/bin/bash

# shellcheck disable=2154,2181

. lib/env.sh

PLIST="${alfred_workflow_bundleid}".plist

START_INTERVAL=$((SyncTime * 60))

# Check for changes
sed "s:WORKFLOW:${alfred_preferences}/workflows/${alfred_workflow_uid}:;s:START_INTERVAL:${START_INTERVAL}:" \
    sync_agent.plist.template > "${PLIST}"

cmp -s "${PLIST}" ~/Library/LaunchAgents/"${PLIST}"

if [ $? != 0 ]; then
    # Copy launch agent plist
    cp -f "${PLIST}" ~/Library/LaunchAgents/

    # Unload launch agent
    launchctl unload -F ~/Library/LaunchAgents/"${PLIST}"

    # Load launch agent
    if [ "${autoSync}" == 1 ]; then
	launchctl load -F ~/Library/LaunchAgents/"${PLIST}"
	launchctl start "${alfred_workflow_bundleid}"

	# [ $((NOW - LAST_SYNC)) -gt ${START_INTERVAL} ] && launchctl start "${alfred_workflow_bundleid}"
    fi
else
    [ "${autoSync}" == 0 ] && launchctl unload -F ~/Library/LaunchAgents/"${PLIST}"    
fi
