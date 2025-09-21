#!/bin/bash

# shellcheck disable=2154,2155

. lib/env.sh

log "${API}/object/${field}/${id}"

# Get item
export ITEM=$(curl -s "${API}/object/${field}/${id}")

# Get item' type
ICON="${PWD}/icon.png"
TYPE=$(jq -j .data.type <<< "${ITEM}")

case ${TYPE} in
    1)
	JQ="login"
	ICON="${PWD}/icons/login.png"
	;;
    2)
	JQ="note"
	ICON="${PWD}/icons/sn.png"
	;;
    3)
	JQ="card"
	BRAND=$(jq -L jq -j 'include "bw"; icon(.)' <<< "${ITEM}")
	ICON="${PWD}/icons/${BRAND}"
	;;
    4)
	JQ="identity"
	ICON="${PWD}/icons/identity.png"
	;;
    5)
	JQ="sshkey"
	ICON="${PWD}/icons/sshkey.png"
	;;
esac

log "Type = ${JQ}"

# Get item's organization
ORG_ID=$(jq -j .data.organizationId <<< "${ITEM}")
ORG=$(jq -j --arg org "${ORG_ID}" '.data.data[] | select(.id == $org) | .name' "${DATA_DIR}"/organizations)

log "Org = ${ORG}"

# Format item
export DATA=$(jq -L jq -j --arg org "${ORG}" -f "jq/show_${JQ}.jq" <<< "${ITEM}")

# Display dialog
2>&- osascript \
    -e 'set t to (system attribute "DATA")' \
    -e 'set i to "'"${ICON}"'"' \
    -e 'display dialog t buttons {"OK"} default button "OK" with title "'"${alfred_workflow_name}"'" with icon posix file i' \
