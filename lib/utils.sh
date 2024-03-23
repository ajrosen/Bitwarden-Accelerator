#!/bin/bash

# shellcheck disable=1090,2034,2154

saveSelection() {
    cat > "${FETCH_FILE}" << EOF
LAST_FETCH=${NOW}
old_objectId=${objectId}
old_field=${field}
old_type=${type}
old_title=${objectName}
old_subtitle=${username}
EOF
}

getSelection() {
    LAST_FETCH=0
    [ -f "${FETCH_FILE}" ] && . "${FETCH_FILE}"
}


# icon "path" [ "type" ]
icon() {
    ICON_PATH="${1}"
    ICON_TYPE="${2}"

    echo '"icon": {'
    echo '"path": "'"${ICON_PATH}"'"'
    [ "${ICON_TYPE}" != "" ] && echo ', "type": "'"${ICON_TYPE}"'"'
    echo '}'
}

# mod "modifier" [ "subtitle" "valid" ]
mod() {
    MOD="${1}"
    SUBTITLE="${2}"
    VALID=${3:-true}

    echo '"'"${MOD}"'": {'
    echo '"valid":' "${VALID}"
    [ "${SUBTITLE}" != "" ] && echo ', "subtitle": "'"${SUBTITLE}"'"'
    echo '}'
}

# mods [ "subtitle" "valid" ]
mods() {
    SUBTITLE="${1}"
    VALID="${2}"

    echo '"mods": {'

    mod "cmd" "${SUBTITLE}" "${VALID}"
    for modifier in "alt" "control" "shift" "function"; do
	echo ", $(mod "${modifier}" "${SUBTITLE}" "${VALID}")"
    done

    echo '}'
}

# text  "copy" "large"
text() {
    COPY="${1}"
    LARGE="${2:-${COPY}}"

    echo '"text": {'

    echo '"copy": "'"${COPY}"'"'
    echo ', "largetype": "'"${LARGE}"'"'

    echo '}'
}

# item "title" [ "arg" "subtitle" "icon" "mods" "copy" "large" ]
item() {
    TITLE="${1}"
    ARG="${2}"
    SUBTITLE="${3}"
    UUID="${4}"
    ICON="${5}"
    MODS="${6}"

    # TEXT
    COPY="${7}"
    LARGE="${8}"

    # VALID
    # MATCH
    # AUTOCOMPLETE
    # TYPE
    # ACTION
    # QUICKLOOKURL

    echo '{'

    echo '  "title": "'"${TITLE}"'"'

    [ "${ARG}" != "" ] && echo -n ', "arg": "'"${ARG}"'"'
    [ "${SUBTITLE}" != "" ] && echo -n ', "subtitle": "'"${SUBTITLE}"'"'
    [ "${UUID}" != "" ] && echo -n ', "uid": "'"${UUID}"'"'
    [ "${ICON}" != "" ] && echo -n ", $(icon "${ICON}")"
    [ "${MODS}" != "" ] && echo -n ", $(mods "${SUBTITLE}")"

    if [ "${COPY}" != "" ] || [ "${LARGE}" != "" ]; then
	echo -n ", $(text "${COPY}" "${LARGE}")"
    fi

    echo '}'
}
