#!/bin/bash

# shellcheck disable=2046

. lib/env.sh

log "syncVault"

saveSync
. lib/status.sh

# YYYY-MM-DDTHH:MM:SS.mmmZ
echo -n "${SYNC}"
