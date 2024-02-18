#!/bin/bash

. lib/env.sh

./stop_server.sh

bw --response logout | jq -r '.message // .data.title'
