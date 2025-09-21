#!/bin/bash

# shellcheck disable=2154

. lib/env.sh
. lib/utils.sh

log "${API}/list/object/items?search=${id}"

objectId=${id}
field=name

saveSelection

echo '{ "items":'

curl -s "${API}/list/object/items?search=${id}" | \
    jq \
	-L jq \
	-r -f jq/show_fields.jq | \
    jq -s flatten

echo '}'
