#!/bin/bash

# shellcheck disable=2068

. lib/env.sh
. lib/status.sh
. lib/utils.sh

[ $# == 0 ] && checkTimeout

if [ "${STATE}" == "unlocked" ]; then
    echo '{ "items": '
    . list_items.sh $@
    echo '}'
else
    osascript -e 'tell application id "com.runningwithcrayons.Alfred" to run trigger "bw" in workflow "org.mlfs.corp.bw"'
fi
