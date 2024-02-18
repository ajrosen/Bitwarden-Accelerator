#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

if [ "${downloadFolder}" == "" ]; then
    downloadFolder=$(osascript -e 'return posix path of (choose folder default location (system attribute "HOME") & "/Downloads")')
fi

curl -s --output-dir "${downloadFolder}" -o "${attachmentName}" "${API}/object/attachment/${attachmentId}?itemid=${id}"

echo "${downloadFolder}"
