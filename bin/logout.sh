#!/bin/bash

. lib/env.sh

log "logout"

./bin/stop_server.sh

bw --response logout | jq -j '.message // .data.title'
rm -f "${DATA_DIR}"/*
sudo -k
