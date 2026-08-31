#!/bin/bash

# shellcheck disable=2181

. lib/env.sh

log "start_server"

# Check if server is already running
2>&- curl -s "${API}"/status > /dev/null

[ $? == 0 ] && exit

log "${bwhost}:${bwport}"

bw serve --hostname "${bwhost}" --port "${bwport}" &>/dev/null & disown

# Check that the server is running
for i in {1..3}; do
    2>&- curl -s "${API}"/status > /dev/null && exit
    sleep 1
done

echo "Server failed to start after three seconds"
exit 1
