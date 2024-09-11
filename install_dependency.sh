#!/bin/bash

# shellcheck disable=2154

alfred_workflow_cache=${alfred_workflow_cache:-"."}

APP="${1}"
PKG="${2}"
EXE="${3}"

BREW=""
PORT=""

# Try installing with a package manager
install () {
    log "Could not find ${APP}"

    dialog='Could not find '"${APP}"'.  Try installing with '"${1}"'?'
    title="${alfred_workflow_name}"
    buttons='{ "Cancel", "Install" }'

    2>&- osascript -e 'display dialog "'"${dialog}"'" with icon stop with title "'"${title}"'" buttons '"${buttons}"' default button "Cancel"' > /dev/null

    if [ $? == 0 ]; then
	echo -n "install"

	osascript -e 'display notification "Installing '"${APP}"'"'
	osascript -e 'tell application "Terminal" to activate'
	osascript -e 'tell application "Terminal" to do script "exec '"${2}"'"'
    fi
}

# Create local symlink
mklink () {
    for D in /usr/local/bin /opt/{homebrew,local}/bin /usr/local/Cellar/"${PKG}"/*/bin /opt/homebrew/Cellar/"${PKG}"/*/bin /run/current-system/sw/bin; do
	if [ -x "${D}/${EXE}" ]; then
	    log "ln -sf ${D}/${EXE} ${alfred_workflow_cache}"

	    mkdir -p "${alfred_workflow_cache}"
	    ln -sf "${D}/${EXE}" "${alfred_workflow_cache}"
	    break
	fi

	# Look for brew and port too
	[ -x "${D}"/brew ] && BREW="${D}"/brew
	[ -x "${D}"/port ] && PORT="${D}"/port
    done
}


##################################################
# Main

# Check symlink
if [ ! -x "${alfred_workflow_cache}/${EXE}" ]; then
    mklink

    # Check again
    [ -x "${alfred_workflow_cache}/${EXE}" ] && exit

    # Offer to install
    if [ "${BREW}" != "" ]; then
	install "Homebrew" "${BREW} install ${PKG}"
    elif [ "${PORT}" != "" ]; then
	install "MacPorts" "sudo ${PORT} -N install ${PKG}"
    fi

    # Once more, with feeling
    [ -x "${alfred_workflow_cache}/${EXE}" ] || echo -n "cancel"
fi
