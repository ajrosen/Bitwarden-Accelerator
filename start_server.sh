#!/bin/bash

# shellcheck disable=2181

. lib/env.sh

# Check if server is already running
curl -s "${API}"/status

[ $? == 0 ] && exit

bw serve --hostname "${bwhost}" --port "${bwport}" &>/dev/null & disown
