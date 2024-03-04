def all:
  {
    title: "All Vaults",
    arg: "",
  }
;

def myVault:
  {
    title: "My Vault",
    arg: "My Vault",
    variables: {
	organizationName: "My Vault",
	organizationId: 0,
      }
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
	organizationName: .name,
	organizationId: .id,
      }
  }
;

##################################################
# Main

[ all ] + [ myVault ] +
[
  .data.data[]
  | select(.name | tostring | test($search; "i"))
  | alfred
]
