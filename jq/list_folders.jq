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

[
  .data.data[]
  | select(.name | tostring | test($search; "i"))
  | alfred
] +
[ {
    title: "👈 Return to More Actions",
    arg: "👈"
  }
]
