#!/bin/bash

# shellcheck disable=2154,2155

. lib/env.sh
. lib/status.sh

log "login with ${loginMethod}"

OUT='{ "success": false, "message": "Login failed" }'

# Make sure server is stopped
./stop_server.sh

# Configure Bitwarden server
log "config server ${serverUrl}"
bw config server "${serverUrl}" >& /dev/null

bwuser=${bwuser:-"user@example.com"}

case "${loginMethod}" in
    "password")
	USER=$(2>&- ./get_username.applescript "${bwuser}")
	[ "${USER}" == "" ] && exit

	export PASS=$(2>&- ./get_password.applescript "Enter Master password for ${bwuser}")
	[ "${PASS}" == "" ] && exit

	CODE=$(./get_code.sh)

	# shellcheck disable=2086
	OUT=$(bw --response --nointeraction login "${USER}" --passwordenv PASS ${CODE})
	;;

    "api_key")
	OUT=$(bw --response --nointeraction login --apikey)
	;;
esac

if [ "$(jq -j .success <<< "${OUT}")" == "true" ] || [[ "$(jq -j .message <<< "${OUT}")" =~ "You are already logged in" ]]; then
    # Start server
    ./start_server.sh
fi

jq -j '.message // .data.title' <<< "${OUT}"
