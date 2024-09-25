##################################################
# Variables

# File locations
SRC_DIR = ~/Sync/GitHub
EXPORTS_DIR = Alfred/Exported\ Workflows

# GitHub
export GITHUB_REPO = Bitwarden-Accelerator

# Release
GH_TAG = bwa

# Workflow
WF_NAME := $(shell /usr/libexec/PlistBuddy -c 'print name' info.plist)
WF_VERSION := $(shell /usr/libexec/PlistBuddy -c 'print version' info.plist)


##################################################
# Targets to run in workflow directory

# Benign default
diff:
	diff --color -r -x '*.plist' -x '.*' ${SRC_DIR}/${GITHUB_REPO} .

diffall:
	diff --color -r ${SRC_DIR}/${GITHUB_REPO} .

# Make sure executables are executable
exec:
	find . \( -name '*.sh' -o -name '*.applescript' -o -name '*.rb' \) -exec chmod -c 755 {} \;

# Copy changed files to repository
checkin: exec
	rsync -av --include=info.plist --exclude=.git --exclude=*.plist . ${SRC_DIR}/${GITHUB_REPO}

# Export workflow
export: exec
	rm -f ${SRC_DIR}/${EXPORTS_DIR}/"${WF_NAME}".alfredworkflow
	zip -qr9 ${SRC_DIR}/${EXPORTS_DIR}/"${WF_NAME}".alfredworkflow . -x prefs.plist -x '.git/*'

all: checkin export


##################################################
# Targets to run in repository directory

# Create new release
release:
	sed -n '1,/^\#/p' CHANGELOG.md | grep -v '^\#\#' | grep . | uniq | github-release release -t ${GH_TAG}-${WF_VERSION} -n "${WF_NAME} ${WF_VERSION}" -d -

upload:
	github-release upload -t ${GH_TAG}-${WF_VERSION} -n Bitwarden.Accelerator.alfredworkflow -R -f ${SRC_DIR}/${EXPORTS_DIR}/"${WF_NAME}".alfredworkflow
