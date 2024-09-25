include "bw";

def allCollections:
  {
    title: "All Collections",
    subtitle: "􀆔 (Cmd) to save as default for future searches",
    arg: 0,
  }
;

# Format an item for Alfred
def alfred:
  {
    title: .name,
    arg: .id,
    autocomplete: .name,
    variables: {
	name, id,
	collectionName: .name,
	collectionId: .id,
      }
  }
;

##################################################
# Main

log(input_filename) |

[ allCollections ] +
[
  .data.data[]
  | select(.name | tostring | test($search; "i"))
  | log([ .id, .name ])
  | select(($organizationId == "0") or ($organizationId == .organizationId))
  | alfred
] +
[ {
    title: "👈 Return to Main Menu",
    arg: "👈"
  }
]
