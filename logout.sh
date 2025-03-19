#!/bin/bash

. lib/env.sh

log "logout"

./stop_server.sh

bw --response logout | jq -j '.message // .data.title'
rm -f "${DATA_DIR}"/*
sudo -k
