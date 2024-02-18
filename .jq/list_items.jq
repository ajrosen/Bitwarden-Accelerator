include "bw";

# Build lookup tables
def objectNames(a):
  [ a[] | select(.id) | { (.id): .name} ] | add
;

.
  | objectNames($folders | fromjson | .data.data) as $folderNames
  | objectNames($collections | fromjson | .data.data) as $collectionNames
  | objectNames($organizations | fromjson | .data.data) as $organizationNames
  |

# Convert folderId to folder name
def folderName(b):
  if b then "\($folderNames[b])" else "no folder" end
;

# Convert organizationId to organization name
def orgName(b):
  if b then "\($organizationNames[b])" else "no organization" end
;

# URIs if there are any
def URIs:
  .login.uris // [] | .[] | .uri
 ;

# Format an item for Alfred
def alfred:
  {
    # uid: .id,
    title: "\(.name) (\(folderName(.folderId)))",
    subtitle: "\(if .favorite then "❤️" else "" end)\(.login.username // "")",
    arg: .id,
    autocomplete: .name,
    icon: { path: (if $icon == "" then "./icons/\(icon(.))" else $icon end) },

    variables: {
	name, id,
	username: .login.username,
	folder: folderName(.folderId),
	url: [ URIs ],
	collections: [ (select(.collectionIds[] | length > 0) | .collectionIds[]) ],
	collectionCount: .collectionIds | length,
	organization: orgName(.organizationId),
	attachmentCount: .attachments | length,
	favorite: (if .favorite then "Unmark" else "Mark" end),
	objectName: .name,
	objectId: .id,
      }
  }
;

# Return searchable fields
def searchFields:
  [
    .name,
    folderName(.folderId),
    .login.username // "",
    URIs,
    .card.brand // "",
    .identity // ""
  ] | tostring
;

##################################################
# Main

[
  # Favorites
  .data.data[] | select(.favorite)
  | select($search == "" or (searchFields | test($search; "i")))
  | select($folderId == "" or $folderId == .folderId)
  | select($collectionId == ""
			 or (.collectionIds[] | test($collectionId)))
  | select(($organizationId == "")
	     or ($organizationId == .organizationId)
	     or (($organizationId == "0") and (.organizationId == null)))
  | alfred
]
  +
[
  # Not favorites
  .data.data[] | select(.favorite | not)
  | select($search == "" or (searchFields | test($search; "i")))
  | select($folderId == ""
		     or $folderId == .folderId)
  | select($collectionId == ""
			 or (.collectionIds[] | test($collectionId)))
  | select(($organizationId == "")
	     or ($organizationId == .organizationId)
	     or (($organizationId == "0") and (.organizationId == null)))
  | alfred
]
