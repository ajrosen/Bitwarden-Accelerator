#!/bin/bash

# shellcheck disable=2034,2154

. lib/env.sh

SUDO_LOCAL=/etc/pam.d/sudo_local
SUDOERS=/etc/sudoers.d/sudoers
export SUDO_ASKPASS=./bin/get_password.applescript


##################################################
# Disable Touch ID in the workflow

disable_tid() {
    # Set pam_tid to false
    osascript -e 'tell application id "com.runningwithcrayons.Alfred" to set configuration "pam_tid" to value false in workflow "'"${alfred_workflow_bundleid}"'"'

    # Notify the user
    MSG="Bitwarden Accelerator requires an Admin account to enable Touch ID"
    MSG+="\n\nTouch ID has been disabled in the workflow"

    osascript -e 'display alert "'"${MSG}"'" as critical'

    exit
}


##################################################
# pam_tid.so must be "sufficient"

check_sudo_local() {
    log "Checking ${SUDO_LOCAL}"

    /usr/bin/grep -qE '^\s*auth\s*sufficient\s*pam_tid.so\s*$' "${SUDO_LOCAL}"
    return $?
}


update_sudo_local() {
    log "Changing ${SUDO_LOCAL}"

    # shellcheck disable=2016
    entry='auth	sufficient	pam_tid.so'

    sudo -A -p "Enter your password to change sudo configuration" sh -c "echo ${entry} >> ${SUDO_LOCAL}"
}


##################################################
# timestamp_type must be "global"

check_sudoers() {
    log "Checking ${SUDOERS}"

    /usr/bin/grep -qE '^\s*Defaults:\s*'"${USER}"'\s*timestamp_type\s*=\s*global\s*$' "${SUDOERS}"
    return $?
}

update_sudoers() {
    log "Changing ${SUDOERS}"

    # shellcheck disable=2016
    entry='Defaults: ${SUDO_USER} timestamp_type = global'

    sudo -A -p "Enter your password to change sudo configuration" sh -c "echo ${entry} >> ${SUDOERS}"
}


##################################################
# Check sudo configuration

check_sudo_local && check_sudoers && exit 0


##################################################
# Check sudo permissions

sudo -ln > /dev/null || disable_tid


##################################################
# Get confirmation

read -r MSG<<EOF
${alfred_workflow_name} needs to change your sudo configuration to enable Touch ID.\n\nClick OK to continue.\n\nSee the documentation for more information.
EOF

A=$(osascript -e "display alert \"${MSG}\" as critical buttons { \"Cancel\", \"OK\" } default button \"Cancel\"")

if [ "${A}" == "button returned:Cancel" ]; then exit 1; fi


##################################################
# Make updates

log "Changing sudo configuration"

sudo -K

check_sudo_local || update_sudo_local
check_sudo_local || exit 1

check_sudoers || update_sudoers
check_sudoers || exit 1

sudo -K

exit 0
