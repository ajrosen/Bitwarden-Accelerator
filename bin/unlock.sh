#!/bin/bash

# shellcheck disable=2034,2154

. lib/env.sh

log "unlock"

export P=""

TID=1


##################################################
# Get master password

# Read password if using Touch ID
if [ "${pam_tid}" == 1 ]; then
    ./bin/configure_tid.sh
    TID=$?

    if [ ${TID} == 0 ]; then
	P=$(sudo -H sh -c 'cd ; cat bwpass.${SUDO_USER}')

	# Delete the bwpass file if it's empty
	[ "${P}" == "" ] && sudo -H sh -c 'cd ; rm -f bwpass.${SUDO_USER}'
    fi
fi

# Maybe prompt for password
if [ "${P}" == "" ]; then
    P=$(2>&- ./bin/get_password.applescript "Enter Master password for ${bwuser}")
fi

# Exit if no password
[ "${P}" == "" ] && exit


##################################################
# Unlock

# Try JSON payload
export J=$(jq -Rnc '{ password: env.P }')
RESPONSE=$(curl -s --variable %J --expand-json '{{J}}' "${API}"/unlock)

# Try key=value payload
if [ "$(jq -j '.success' <<< "${RESPONSE}")" != "true" ]; then
    RESPONSE=$(curl -s --variable %P --expand-data 'password={{P}}' "${API}"/unlock)
fi

##################################################
# Save password if using Touch ID

if [ "${pam_tid}" == 1 ] && [ ${TID} == 0 ]; then
    if [ "$(jq -j '.success' <<< "${RESPONSE}")" != "true" ]; then
	# Master password was incorrect.  Remove it from the cache.
	sudo -H sh -c 'cd ; rm -f bwpass.${SUDO_USER}'
    else
	# Master password was correct.  Store it in the cache.
	sudo -H --preserve-env=P sh -c 'cd ; umask 077 ; echo "${P}" > bwpass.${SUDO_USER}'
    fi
fi

jq -j '.message // .data.title' <<< "${RESPONSE}"
