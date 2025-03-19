#!/bin/bash

# shellcheck disable=2034,2154

. lib/env.sh

log "unlock"

SUDO_ASKPASS=./get_password.applescript
export p=""

TID=1


##################################################
# Get master password

# Read password if using Touch ID
if [ "${pam_tid}" == 1 ]; then
    ./configure_tid.sh
    TID=$?

    if [ ${TID} == 0 ]; then
	p=$(sudo -A -H -p "Enter your system password to unlock your vault with Touch ID" sh -c 'cd ; cat bwpass.${SUDO_USER}')
    fi
fi

# Maybe prompt for password
if [ "${p}" == "" ]; then
    p=$(2>&- ./get_password.applescript "Enter Master password for ${bwuser}")
fi

# Exit if no password
[ "${p}" == "" ] && exit


##################################################
# Login

# Try JSON payload
RESPONSE=$(curl -s -H 'Content-Type: application/json' -d '{"password": "'"${p}"'"}' "${API}"/unlock)

# Try key=value payload
if [ "$(jq -j '.success' <<< "${RESPONSE}")" != "true" ]; then
    RESPONSE=$(curl -s -d "password=${p}" "${API}"/unlock)
fi


##################################################
# Save password if using Touch ID

if [ "${pam_tid}" == 1 ] && [ ${TID} == 0 ]; then
    if [ "$(jq -j '.success' <<< "${RESPONSE}")" != "true" ]; then
	# Master password was incorrect.  Remove it from the cache.
	sudo -A -H -p "Invalid master password.  Enter your system password to reset Touch ID." sh -c 'cd ; rm -f bwpass.${SUDO_USER}'
    else
	# Master password was correct.  Store it in the cache.
	sudo -A -H -p "Enter your system password to enable Touch ID" --preserve-env=p sh -c 'cd ; umask 077 ; echo "${p}" > bwpass.${SUDO_USER}'
    fi
fi

jq -j '.message // .data.title' <<< "${RESPONSE}"
