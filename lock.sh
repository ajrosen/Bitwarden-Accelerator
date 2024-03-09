#!/bin/bash

. lib/env.sh

log "lock"

curl -s -X POST "${API}"/lock | jq -r '.message // .data.title'
rm -f "${DATA_DIR}"/*
