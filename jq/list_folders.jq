include "bw";

# Format an item for Alfred
def alfred:
  {
    title: .name,
    arg: .id,
    autocomplete: .name,
    icon: { path: "./icons/folder.png" },
    variables: {
	name, id,
	folderName: .name,
	folderId: .id,
      }
  }
;

##################################################
# Main

log(input_filename) |

[
  .data.data[]
  | select(.name | tostring | test($search; "i"))
  | log([ .id, .name ])
  | alfred
] +
[ {
    title: "👈 Return to More Actions",
    arg: "👈"
  }
]
