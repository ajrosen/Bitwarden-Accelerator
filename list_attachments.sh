#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

echo '{ "items":'

ITEM=$(curl -s "${API}"/object/item/"${id}")

jq \
    -L jq \
    --arg search "$*" \
    -r -f jq/list_attachments.jq \
    <<< "${ITEM}"

echo '}'
