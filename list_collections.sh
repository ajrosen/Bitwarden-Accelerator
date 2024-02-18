#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

echo '{ "items":'

jq \
    -L .jq \
    --arg organizationId "${ORGANIZATION_ID}" \
    --arg search "$*" \
    -r -f .jq/list_collections.jq \
    "${DATA_DIR}"/collections

echo '}'
