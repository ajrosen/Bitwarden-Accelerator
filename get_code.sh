#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

[ "${twoStepMethod}" == "" ] && exit

if [ "${twoStepMethod}" == "1" ]; then
    log "Trigger email authentication"

    bw --nointeraction login "${bwuser}" --method "${twoStepMethod}" --passwordenv PASS
fi

CODE=$(./get_code.applescript "${twoStepMethod}")

log "2FA ${twoStepMethod} ${CODE}"

echo "--method ${twoStepMethod} --code ${CODE}"
