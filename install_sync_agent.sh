#!/bin/bash

# shellcheck disable=2002,2154,2181

. lib/env.sh

AGENT_DIR=${HOME}/Library/LaunchAgents
PLIST="${alfred_workflow_bundleid}".plist
AGENT=${AGENT_DIR}/"${PLIST}"

START_INTERVAL=$((SyncTime * 60))

function load() {
    launchctl load -F "${AGENT}"
    launchctl start "${alfred_workflow_bundleid}"
}

function unload() {
    launchctl unload -F "${AGENT}"
}

# Check for changes
cat sync_agent.plist.template \
    | sed "s:WORKFLOW:${alfred_preferences}/workflows/${alfred_workflow_uid}:" \
    | sed "s:START_INTERVAL:${START_INTERVAL}:" \
    | sed "s:BUNDLEID:${alfred_workflow_bundleid}:" \
	  > "${PLIST}"

cmp -s "${PLIST}" "${AGENT}"

if [ $? != 0 ]; then
    # Changes made
    # Copy launch agent plist
    [ -d "${AGENT_DIR}"/ ] || mkdir -p "${AGENT_DIR}"/
    cp -f "${PLIST}" "${AGENT_DIR}"/

    # Unload launch agent
    unload

    # Load launch agent
    if [ "${autoSync}" == 1 ]; then
	log "Loading ${AGENT} ${alfred_workflow_bundleid}"
	load
    fi
else
    # No changes made
    if [ "${autoSync}" == 0 ]; then
	log "Unloading ${AGENT}"
	unload
    else
	launchctl list "${alfred_workflow_bundleid}" > /dev/null
	if [ $? != 0 ]; then load; fi
    fi
fi
