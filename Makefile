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
WF_NAME := $(shell plutil -extract name raw info.plist)
WF_VERSION := $(shell plutil -extract version raw info.plist)
VERSION := $(WF_VERSION)


##################################################
# Targets to run in workflow directory

# Benign default
diff:
	@diff --color -r -x '*.plist' -x '.*' ${SRC_DIR}/${GITHUB_REPO} . || true

diffall:
	@diff --color -r ${SRC_DIR}/${GITHUB_REPO} . || true

diffq:
	@diff --color -qr ${SRC_DIR}/${GITHUB_REPO} . || true

# Make sure executables are executable
exec:
	find . \( -name '*.sh' -o -name '*.applescript' -o -name '*.rb' \) -exec chmod -c 755 {} \;

# Update version
version:			# make version VERSION=1.2.3
	plutil -replace version -string $(VERSION) info.plist
	sed -i "s:^\*Version $(WF_VERSION)\*</string>:\*Version $(VERSION)\*</string>:" info.plist

# Copy changed files to repository
checkin: exec
	rsync -av --include=info.plist --exclude=.git --exclude=*.plist . ${SRC_DIR}/${GITHUB_REPO}

# Export workflow
export: exec version
	rm -f ${SRC_DIR}/${EXPORTS_DIR}/"${WF_NAME}".alfredworkflow
	zip -qr9 ${SRC_DIR}/${EXPORTS_DIR}/"${WF_NAME}".alfredworkflow . -x prefs.plist -x '.git/*'

all: export checkin


##################################################
# Targets to run in repository directory

# View changes
changelog:
	@sed -n '1,/^#/p' CHANGELOG.md | grep -v '^##' | grep . | uniq

# Create new release
release:
	sed -n '1,/^#/p' CHANGELOG.md | grep -v '^##' | grep . | uniq | github-release release -t ${GH_TAG}-${WF_VERSION} -n "${WF_NAME} ${WF_VERSION}" -d -

# Upload exported workflow
upload:
	github-release upload -t ${GH_TAG}-${WF_VERSION} -n Bitwarden.Accelerator.alfredworkflow -R -f ${SRC_DIR}/${EXPORTS_DIR}/"${WF_NAME}".alfredworkflow
