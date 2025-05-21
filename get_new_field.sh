#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

log "get_new_field"

# Perform operation and sync vault
function mkchange() {
    URL="${API}"/object/item/"${objectId}"

    if [ "${op}" == "remove" ]; then
	# Remove item
	curl -s "${URL}" \
	    | jq ".data | del(${jqItem})" \
	    | curl -s -H 'Content-Type: application/json' -T - "${URL}" \
	    | jq .success
    else
	# Update item
	curl -s "${URL}" \
	    | jq ".data | ${jqItem} |= \"$(cut -d: -f3 <<< "${new}")\"" \
	    | curl -s -H 'Content-Type: application/json' -T - "${URL}" \
	    | jq .success
    fi

    saveSync
}

# First dialog to get action
function mkscript1() {
    script='display dialog "'"${1}"'"'
    script="${script} buttons { \"OK\", \"Remove ${editField}\", \"Cancel\" }"
    script="${script} default button \"OK\""
    script="${script} default answer \"\""
    script="${script} with title \"Change ${editField}\""
    [ "${editField}" == "password" ] && script="${script} with hidden answer"
}

# Second dialog to confirm removal
function mkscript2() {
    script='display dialog "'"${1}"'"'
    script="${script} buttons { \"Cancel\", \"OK\" }"
    script="${script} default button \"Cancel\""
    script="${script} with title \"Remove ${editField}\""
    script="${script} with icon caution"
}

# Third dialog to confirm entry
function mkscript3() {
    script='display dialog "'"${1}"'"'
    script="${script} buttons { \"OK\", \"Cancel\" }"
    script="${script} default button \"OK\""
    script="${script} default answer \"\""
    script="${script} with title \"Change ${editField}\""
    [ "${editField}" == "password" ] && script="${script} with hidden answer"
}

# Get item path to edit
case "${editField}" in
    "username")
	jqItem=".login.username"
	;;
    "password")
	jqItem=".login.password"
	;;
    "generate")
	jqItem=".login.password"
	new="$(./generate_password.sh)"
	mkchange
	exit 0
	;;
    "TOTP")
	jqItem=".login.totp"
	;;
    "name")
	jqItem=".name"
	;;
    *)
	osascript -e 'display notification "Unknown field: '"${editField}"'"'
	exit 0
esac

# Prompt for new value
mkscript1 "Enter new ${editField}:"
new=$(2>&- osascript -e "${script}")

# Exit if canceled or no entry
[ "${new}" == "" ] && exit 0
[ "${new}" == "button returned:OK, text returned:" ] && exit 0

# Confirm removal
if [[ "${new}" =~ "button returned:Remove" ]]; then
    mkscript2 "Are you sure you want to remove ${editField}?"
    yorn=$(2>&- osascript -e "${script}")

    # Exit if canceled
    [ "${yorn}" != "button returned:OK" ] && exit 0

    op="remove"
fi

# Confirm value if password and not removing
if [ "${editField}" == "Password" ] && [ "${op}" != "remove" ]; then
    mkscript3 "Confirm new password"
    again=$(2>&- osascript -e "${script}")

    # Exit if canceled
    [ "${again}" == "" ] && exit 0

    if [ "${new}" != "${again}" ]; then
	osascript -e 'display notification "Passwords do not match"'
	exit 0
    fi
fi

# Make the change
mkchange
