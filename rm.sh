#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

curl -s -X DELETE "${API}"/object/item/"${id}" > /dev/null
saveSync

echo "${name}"
