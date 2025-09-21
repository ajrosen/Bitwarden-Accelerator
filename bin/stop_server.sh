#!/bin/bash

# shellcheck disable=

. lib/env.sh

log "stop_server"

# Get PID of Bitwarden server
BWPID=$(lsof -t -iTCP@"${bwhost}":"${bwport}")

[ "${BWPID}" == "" ] && exit 0

log "PID = ${BWPID}"

kill "${BWPID}"
