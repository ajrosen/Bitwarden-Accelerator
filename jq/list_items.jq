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
def folderName(b; fn):
  if b then "\(fn[b])" else "no folder" end
;

# Convert organizationId to organization name
def orgName(b; on):
  if b then "\(on[b])" else "no organization" end
;

# URIs if there are any
def URIs:
  .login.uris // [] | .[] | .uri
 ;


# Set subtitle based on fields present in the item
def subtitle:
  if .login.username then
    .login.username
  elif .sshKey then
    "Copy private key to clipboard"
  elif .card.cardholderName then
    .card.cardholderName
  elif .type == 2 then
    "Copy note to clipboard"
  else ""
    end
 ;

def favicon:
  if env.favicons != "None" and .login.uris[0].uri then
    .login.uris[0].uri | "\(env.FAVICONS_DIR)/\(split("/")[2])"
  else
    "./icons/\(icon(.))"
  end
 ;

# Format an item for Alfred
def alfred(fn; on):
  {
    # uid: .id,
    title: "\(.name) (\(folderName(.folderId; fn)))",
    subtitle: "\(if .favorite then "❤️ " else "" end)\(subtitle)",
    arg: .id,
    autocomplete: .name,
    icon: { path: (if $icon == "" then favicon else $icon end) },

    variables: {
	name, id,
	username: .login.username,
	folder: folderName(.folderId; fn),
	url: [ URIs ],
	default_url: .login.uris[0].uri,
	collections: [ (select(.collectionIds + [] | length > 0) | .collectionIds[]) ],
	collectionCount: .collectionIds | length,
	organization: orgName(.organizationId; on),
	attachmentCount: .attachments | length,
	favorite: (if .favorite then "Unmark" else "Mark" end),
	objectName: .name,
	objectId: .id,
	revisionDate: .revisionDate,
	type: .type,
      }
  }
;

# Return searchable fields
def searchFields:
  [
    .name,
    .id,
    folderName(.folderId; $folderNames),
    .login.username // "",
    URIs,
    .card.brand // "",
    .identity // ""
  ] | tostring
;

def filter:
. | select($search == "" or (searchFields | test($search; "i")))
  | select($folderId == "" or $folderId == .folderId)
  | select($collectionId == "0" or ($collectionId == "")
			 or (.collectionIds[] | test($collectionId)))
  | select(($organizationId == "0") or ($organizationId == .organizationId)
	     or (($organizationId == "1") and (.organizationId == null)))
;

##################################################
# Main

log(input_filename) |

if $recent != "" then
  # Recent
  [
    .data.data[] | select(.id == $recent)
    | filter
    | alfred($folderNames; $organizationNames)      
  ]
else
  [
    # Favorites
    .data.data[] | select(.id != $skip) | select(.favorite)
    | filter
    | alfred($folderNames; $organizationNames)
  ]

    +

  [
    # Not favorites
    .data.data[] | select(.id != $skip) | select(.favorite | not)
    | filter
    | alfred($folderNames; $organizationNames)
  ]
end

  | log("\(length) items")
