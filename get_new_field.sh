#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

function mkscript() {
    script='return text returned of (display dialog "'"${1}"'"'
    script="${script} buttons { \"OK\", \"Cancel\" }"
    script="${script} default button \"OK\""
    script="${script} default answer \"\""
    script="${script} with title \"Change ${editField}\""
    [ "${editField}" == "Password" ] && script="${script} with hidden answer"
    script="${script})"
}

# Get item
jqItem=".login.username"
[ "${editField}" == "Password" ] && jqItem=".login.password"
[ "${editField}" == "Name" ] && jqItem=".name"

# Prompt for new value
mkscript "Enter new value:"
new=$(osascript -e "${script}")

# Exit if canceled
[ "${new}" == "" ] && exit 0

# Confirm value if password
if [ "${editField}" == "Password" ]; then
    mkscript "Confirm new password"
    again=$(osascript -e "${script}")

    if [ "${new}" != "${again}" ]; then
	osascript -e 'display notification "Passwords do not match"'
	exit 0
    fi
fi

# Update item
URL="${API}"/object/item/"${objectId}"

curl -s "${URL}" \
    | jq ".data | ${jqItem} |= \"${new}\"" \
    | curl -s -H 'Content-Type: application/json' -T - "${URL}" \
    | jq .success

saveSync
