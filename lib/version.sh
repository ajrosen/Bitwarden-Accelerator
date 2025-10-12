#!/bin/bash

# shellcheck disable=2154

log "Check version"

VERS=$(curl -qsI https://github.com/ajrosen/Bitwarden-Accelerator/releases/latest \
	   | awk -F - '/^location:/ { if ($NF != "'"${alfred_workflow_version}"'\r") { printf("%s", $NF) } }' \
	   | grep -o '[0-9.]*')

if [ "${VERS}" != "" ]; then
    log "Current version ${alfred_workflow_version} != ${VERS}"

    SCRIPT='tell application id "com.runningwithCrayons.Alfred" to run trigger "version" in workflow "'
    SCRIPT+="${alfred_workflow_bundleid}"
    SCRIPT+='" with argument "'
    SCRIPT+="${VERS//#[2-9.]/}"
    SCRIPT+='"'

    osascript -e "${SCRIPT}"
fi
