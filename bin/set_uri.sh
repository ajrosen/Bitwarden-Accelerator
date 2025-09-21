#!/bin/bash

# shellcheck disable=2154

. lib/env.sh

log "set_uri"

URL="${API}"/object/item/"${objectId}"

# Delete a URI
if [ "${uriop}" == "delete" ]; then
    NEW_ITEM=$(./bin/set_uri.rb delete "${1}")
else
    # Get old URI
    case "${uriop}" in
	add)
	    OLD_URI=""
	    ;;
	edit)
	    OLD_URI="${1}"	    
	    ;;
	*)
	    exit
    esac

    # Get new URI
    NEW_URI=$(./bin/get_url.applescript "${1}")
    if [ "${NEW_URI}" == "" ]; then exit 0; fi

    # Get modified item
    NEW_ITEM=$(./bin/set_uri.rb "${uriop}" "${OLD_URI}" "${NEW_URI}")
fi

# Update item
curl -s "${URL}" \
    | jq ".data | .login.uris |= ${NEW_ITEM}" \
    | curl -s -H 'Content-Type: application/json' -T - "${URL}" \
    | jq .success

saveSync
