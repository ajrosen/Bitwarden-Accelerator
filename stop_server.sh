#!/bin/bash

# shellcheck disable=

. lib/env.sh

# Get PID of Bitwarden server
BWPID=$(lsof -t -iTCP@"${bwhost}":"${bwport}")

[ "${BWPID}" == "" ] && exit 0

kill "${BWPID}"
