#!/bin/bash

# shellcheck disable=2002,2154,2181

. lib/env.sh

PLIST="${alfred_workflow_bundleid}".plist

START_INTERVAL=$((SyncTime * 60))

# Check for changes
cat sync_agent.plist.template \
    | sed "s:WORKFLOW:${alfred_preferences}/workflows/${alfred_workflow_uid}:" \
    | sed "s:START_INTERVAL:${START_INTERVAL}:" \
    | sed "s:BUNDLEID:${alfred_workflow_bundleid}:" \
	  > "${PLIST}"

cmp -s "${PLIST}" ~/Library/LaunchAgents/"${PLIST}"

if [ $? != 0 ]; then
    # Copy launch agent plist
    [ -d ~/Library/LaunchAgents/ ] || mkdir -p ~/Library/LaunchAgents/
    cp -f "${PLIST}" ~/Library/LaunchAgents/

    # Unload launch agent
    launchctl unload -F ~/Library/LaunchAgents/"${PLIST}"

    # Load launch agent
    if [ "${autoSync}" == 1 ]; then
	log "Loading ~/Library/LaunchAgents/${PLIST} ${alfred_workflow_bundleid}"

	launchctl load -F ~/Library/LaunchAgents/"${PLIST}"
	launchctl start "${alfred_workflow_bundleid}"
    fi
else
    if [ "${autoSync}" == 0 ]; then
	log "Unloading ~/Library/LaunchAgents/${PLIST}"

	launchctl unload -F ~/Library/LaunchAgents/"${PLIST}"
    fi
fi
