#!/bin/bash

# shellcheck disable=2154,2155

. lib/env.sh
. lib/status.sh

OUT='{ "message": "Login failed" }'

# Make sure server is stopped
./stop_server.sh

bwuser=${bwuser:-"user@example.com"}

case "${loginMethod}" in
    "password")
	USER=$(./get_username.applescript "${bwuser}")
	[ "${USER}" == "" ] && exit

	export PASS=$(./get_password.applescript "${bwuser}")
	[ "${PASS}" == "" ] && exit

	CODE=$(./get_code.sh)

	# shellcheck disable=2086
	OUT=$(bw --response --nointeraction login "${USER}" --passwordenv PASS ${CODE})
	;;

    "api_key")
	OUT=$(bw --response --nointeraction login --apikey)
	;;
esac

# Start server
./start_server.sh

jq -r '.message // .data.title' <<< "${OUT}"
