#!/bin/bash

# shellcheck disable=2046

. lib/env.sh

saveSync
. lib/status.sh

# YYYY-MM-DDTHH:MM:SS.mmmZ
jq -r '.lastSync | "\(.[0:19])Z" | fromdate | strflocaltime("%c %Z")' "${STATUS_FILE}"
