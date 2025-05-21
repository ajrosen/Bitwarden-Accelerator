#!/bin/bash

# shellcheck disable=1091

. lib/env.sh

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
# Passwords are generated if PASSPHRASE is "false".  All boolean
# settings are enabled unless the value is "false".  Numeric settings
# use the default if their value is not numeric.

# Passwords
LENGTH=20
UPPERCASE=true
LOWERCASE=t
NUMBER=yes
SPECIAL=on

# Passphrases
PASSPHRASE=false
WORDS=6
SEPARATOR=:
CAPITALIZE=true


##################################################
# Set options

if [ "${PASSPHRASE}" == "false" ]; then
    # Generate a random password
    OPTS="length=${LENGTH}"
    [ "${UPPERCASE}" == "false" ] || OPTS="${OPTS}&uppercase"
    [ "${LOWERCASE}" == "false" ] || OPTS="${OPTS}&lowercase"
    [ "${NUMBER}" == "false" ] || OPTS="${OPTS}&number"
    [ "${SPECIAL}" == "false" ] || OPTS="${OPTS}&special"
else
    # Generate a random passphrase
    OPTS="passphrase=1&words=${WORDS}&separator=${SEPARATOR}"
    [ "${CAPITALIZE}" == "false" ] || OPTS="${OPTS}&capitalize"
fi


##################################################
# Generate password or passphrase

curl -s "${API}/generate?${OPTS}" | jq -r .data.data
