#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

curl -s -d "password=${*}" "${API}"/unlock | jq -r '.message // .data.title'
