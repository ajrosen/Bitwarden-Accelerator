##################################################
# Variables

# File locations
SRC_DIR = ~/GitHub/Alfred
EXPORTS_DIR = Alfred/Exported Workflows

# GitHub
export GITHUB_REPO = Bitwarden-Accelerator

# Release
MANIFEST=bin bwa-sync icon.png icons info.plist jq lib sync_agent.plist.template
GH_TAG = bwa

# Workflow
WF_DIR = workflow
WF_NAME := $(shell plutil -extract name raw info.plist)
WF_VERSION := $(shell plutil -extract version raw info.plist)

VERSION := $(WF_VERSION)


##################################################
# Targets to run in workflow directory

# Benign default
diff:
	diff --color -x \*.plist -r ${WF_DIR} . | grep -v '^Only in \.:' || true

diffq:
	diff --color -x \*.plist -qr ${WF_DIR} . | grep -v '^Only in \.:' || true

# Update version
version:			# make version VERSION=1.2.3
	plutil -replace version -string $(VERSION) info.plist
	sed -i "s:^\*Version $(WF_VERSION)\*</string>:\*Version $(VERSION)\*</string>:" info.plist

# Copy changed files to repository
checkin:
	rsync -aq --exclude=*.plist --include=info.plist ${WF_DIR}/ .
	find . \( -name '*.sh' -o -name '*.applescript' -o -name '*.rb' \) -exec chmod -c 755 {} \;
	@$(MAKE) --no-print-directory sanitize

# Sanitize files for export
sanitize:
	plutil -extract variablesdontexport json -o - info.plist | jq '.[]' | xargs -I % plutil -replace variables.% -string '' info.plist

# Export workflow
export: sanitize
	zip -qr9 ${SRC_DIR}/"${EXPORTS_DIR}"/"${WF_NAME}".alfredworkflow ${MANIFEST}


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
	github-release upload -t ${GH_TAG}-${WF_VERSION} -n Bitwarden.Accelerator.alfredworkflow -R -f ${SRC_DIR}/"${EXPORTS_DIR}"/"${WF_NAME}".alfredworkflow
