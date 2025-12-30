#!/bin/bash

# shellcheck disable=2154,2162

log "Check version"

# Notify user
osa() {
    SCRIPT='tell application id "com.runningwithCrayons.Alfred" to run trigger "version" in workflow "'
    SCRIPT+="${alfred_workflow_bundleid}"
    SCRIPT+='" with argument "'
    SCRIPT+="${VERS//#[2-9.]/}"
    SCRIPT+='"'

    osascript -e "${SCRIPT}"
    exit 0
}

# Get released version
VERS=$(curl -qsI https://github.com/ajrosen/Bitwarden-Accelerator/releases/latest \
	   | awk -F - '/^location:/ { if ($NF != "'"${alfred_workflow_version}"'\r") { printf("%s", $NF) } }' \
	   | grep -o '[0-9.]*')

# Compare current and released versions
if [ "${VERS}" != "" ]; then
    log "Current version ${alfred_workflow_version} != ${VERS}"

    # Split current and released versions into major, minor, and patch numbers
    read -a cur <<< "${alfred_workflow_version//./ }"
    read -a rel <<< "${VERS//./ }"

    # Make sure the relesed version is newer than the current version
    if [ "${rel[0]}" -gt "${cur[0]}" ]; then osa; fi
    if [ "${rel[1]}" -gt "${cur[1]}" ]; then osa; fi
    if [ "${rel[2]}" -gt "${cur[2]}" ]; then osa; fi
fi
