#!/bin/bash

# shellcheck disable=2181

. lib/env.sh

log "start_server"

# Check if server is already running
curl -s "${API}"/status

[ $? == 0 ] && exit

log "${bwhost}:${bwport}"

bw serve --hostname "${bwhost}" --port "${bwport}" &>/dev/null & disown
