#!/bin/bash

# shellcheck disable=2154

. lib/utils.sh

echo '{ "items": [ '

# Add a URI
echo -n ' { "title": "Add a URI", "subtitle": "'"${objectName}"'", "arg": "+", "variables": { "uriop": "add" },'
mods "${objectName}" true
echo '}'

IFS=$'\t'

for URI in ${uris}; do
    echo -n ',{ "title": "'
    echo -n "${URI}"
    echo -n '", "subtitle": "'
    echo -n " "
    echo -n '", "arg": "'
    echo -n "${URI}"
    echo -n '", "variables": { "uriop": "edit" }'
    echo -n ', "mods": { "cmd": { "valid": "true", "subtitle": "Delete URI", "variables": { "uriop": "delete" } } }'
    echo '}'
done


echo -n ', { "title": "👈 Return to Edit Item menu", "arg": "👈", "variables": { "uriop": "return" } }'

echo '] }'
