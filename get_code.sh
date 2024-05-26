#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

[ "${twoStepMethod}" == "" ] && exit

log "2FA ${twoStepMethod}"

if [ "${twoStepMethod}" == "1" ]; then
    log "Trigger email authentication"

    bw --nointeraction login "${bwuser}" --method "${twoStepMethod}" --passwordenv PASS
fi

CODE=$(./get_code.applescript "${twoStepMethod}")

echo "--method ${twoStepMethod} --code ${CODE}"
