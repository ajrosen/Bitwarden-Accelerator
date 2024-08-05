def all:
  {
    title: "All Collections",
    arg: "",
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

[ all ] +
[
  .data.data[]
  | select(.name | tostring | test($search; "i"))
  | select(($organizationId == "") or ($organizationId == .organizationId) or (($organizationId == "0") and (.organizationId == null)))
  | alfred
] +
[ {
    title: "👈 Return to Main Menu",
    arg: "👈"
  }
]
