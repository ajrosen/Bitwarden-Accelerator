##################################################
# Variables

# File locations
SRC_DIR = ~/GitHub
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
	rsync -av --include=info.plist --exclude=.git* --exclude=*.plist --exclude=doc --delete . ${SRC_DIR}/${GITHUB_REPO}

# Create .workflow file
workflow: exec
	zip -qr9 "${WF_NAME}".alfredworkflow . -x prefs.plist -x '.git/*'

# Export workflow
export:
	@echo "Export workflow to ${SRC_DIR}/${EXPORTS_DIR}/${WF_NAME}.alfredworkflow"
	@osascript -e 'tell application id "com.runningwithcrayons.Alfred" to reveal workflow "org.mlfs.corp.bw"'

all: checkin export


##################################################
# Targets to run in repository directory

# View changes
changelog:
	@sed -n '1,/^#/p' CHANGELOG.md | grep -v '^#' | grep .

# Create new release
release:
	sed -n '1,/^#/p' CHANGELOG.md | grep -v '^#' | grep . | github-release release -t ${GH_TAG}-${WF_VERSION} -n "${WF_NAME} ${WF_VERSION}" -d -

# Upload exported workflow
upload:
	github-release upload -t ${GH_TAG}-${WF_VERSION} -n Bitwarden.Accelerator.alfredworkflow -R -f ${SRC_DIR}/${EXPORTS_DIR}/"${WF_NAME}".alfredworkflow
