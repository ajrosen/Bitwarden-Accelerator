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
DATA=$(jq -L jq -j --arg org "${ORG}" -f "jq/show_${JQ}.jq" <<< "${ITEM}")

# Display dialog.
#
# Do not pass the formatted item text through an environment variable. Non-ASCII
# text, especially CJK characters, may be decoded incorrectly by AppleScript
# when read via `system attribute`. Store the text as UTF-8 and pass only paths
# and metadata as argv.
TMP_DATA=$(mktemp "${TMPDIR:-/tmp}/bwa-item-data.XXXXXX")
TMP_SCRIPT=$(mktemp "${TMPDIR:-/tmp}/bwa-item-script.XXXXXX.applescript")

printf '%s' "$DATA" > "$TMP_DATA"

cat > "$TMP_SCRIPT" <<'APPLESCRIPT'
on run argv
  set dataPath to item 1 of argv
  set iconPath to item 2 of argv
  set dialogTitle to item 3 of argv

  set t to read POSIX file dataPath as «class utf8»

  display dialog t buttons {"OK"} default button "OK" with title dialogTitle with icon POSIX file iconPath
end run
APPLESCRIPT

trap 'rm -f "$TMP_DATA" "$TMP_SCRIPT"' EXIT

2>&- osascript "$TMP_SCRIPT" "$TMP_DATA" "$ICON" "$alfred_workflow_name"
