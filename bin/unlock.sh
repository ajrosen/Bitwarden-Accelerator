#!/bin/bash

# shellcheck disable=2034,2154

. lib/env.sh

log "unlock"

export p=""

TID=1


##################################################
# Get master password

# Read password if using Touch ID
if [ "${pam_tid}" == 1 ]; then
    ./bin/configure_tid.sh
    TID=$?

    if [ ${TID} == 0 ]; then
	p=$(sudo -H sh -c 'cd ; cat bwpass.${SUDO_USER}')
    fi
fi

# Maybe prompt for password
if [ "${p}" == "" ]; then
    p=$(2>&- ./bin/get_password.applescript "Enter Master password for ${bwuser}")
fi

# Exit if no password
[ "${p}" == "" ] && exit


##################################################
# Unlock
#
# The password is sent to `bw serve`'s /unlock endpoint via curl's stdin
# (--data @-) instead of as a -d/--data command-line argument, so it never
# appears in this process's argv and is not visible to other local
# processes via `ps`. The JSON body itself is built with `jq -Rs`, which
# reads the raw password from stdin too, so jq's argv is never touched
# either. This also fixes JSON-escaping for passwords containing quotes
# or backslashes, which the previous string-interpolated payload mishandled.

# Try JSON payload
RESPONSE=$(printf '%s' "${p}" | jq -Rsc '{password: .}' | curl -s -H 'Content-Type: application/json' --data @- "${API}"/unlock)

# Try key=value payload
if [ "$(jq -j '.success' <<< "${RESPONSE}")" != "true" ]; then
    RESPONSE=$(printf '%s' "${p}" | curl -s --data-urlencode "password@-" "${API}"/unlock)
fi

##################################################
# Save password if using Touch ID

if [ "${pam_tid}" == 1 ] && [ ${TID} == 0 ]; then
    if [ "$(jq -j '.success' <<< "${RESPONSE}")" != "true" ]; then
	# Master password was incorrect.  Remove it from the cache.
	sudo -H sh -c 'cd ; rm -f bwpass.${SUDO_USER}'
    else
	# Master password was correct.  Store it in the cache.
	sudo -H --preserve-env=p sh -c 'cd ; umask 077 ; echo "${p}" > bwpass.${SUDO_USER}'
    fi
fi

jq -j '.message // .data.title' <<< "${RESPONSE}"
