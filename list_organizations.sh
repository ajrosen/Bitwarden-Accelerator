#!/bin/bash

. lib/env.sh

echo '{ "items":'

jq \
    -L .jq \
    --arg search "$*" \
    -r -f .jq/list_organizations.jq \
    "${DATA_DIR}"/organizations

echo '}'
