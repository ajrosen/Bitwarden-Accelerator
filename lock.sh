#!/bin/bash

. lib/env.sh

curl -s -X POST "${API}"/lock | jq -r '.message // .data.title'
