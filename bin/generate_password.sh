#!/bin/bash

# shellcheck disable=1091

. lib/env.sh

log "generate_password"

# Bitwarden's default settings for its password generator are:
#
# Passwords of 14 characters, using uppercase letters, lowercase
# letters, and numbers, but no special characters
#
# The defaults when generating passphrases are six words separated by
# hyphens, not capitalized.
#
# The settings below generate more complex passwords than the
# defaults.  Make any desired changes to the settings here.
#
# Passwords are generated if PHRASE is "false".  All boolean
# settings are enabled unless the value is "false".  Numeric settings
# use the default if their value is not numeric.

# Passwords
LEN=20
UPPER=true
LOWER=t
NUM=yes
SPEC=on

# Passphrases
PHRASE=false
WORDS=6
SEP=:
CAP=true

log "Options: ${LEN}, ${UPPER}, ${LOWER}, ${NUM}, ${SPEC}, ${PHRASE}, ${WORDS}, ${SEP}, ${CAP}"


##################################################
# Set options

if [ "${PHRASE}" == "false" ]; then
    # Generate a random password
    OPTS="length=${LEN}"
    [ "${UPPER}" == "false" ] || OPTS="${OPTS}&uppercase"
    [ "${LOWER}" == "false" ] || OPTS="${OPTS}&lowercase"
    [ "${NUM}" == "false" ] || OPTS="${OPTS}&number"
    [ "${SPEC}" == "false" ] || OPTS="${OPTS}&special"
else
    # Generate a random passphrase
    OPTS="passphrase=1&words=${WORDS}&separator=${SEP}"
    [ "${CAP}" == "false" ] || OPTS="${OPTS}&capitalize"
fi


##################################################
# Generate password or passphrase

curl -s "${API}/generate?${OPTS}" | jq -r .data.data
