include "bw";

def allVaults:
  {
    title: "All Vaults",
    subtitle: "􀆔 (Cmd) to save as default for future searches",
    arg: 0,
  }
;

def myVault:
  {
    title: "My Vault",
    arg: 1,
    variables: {
	organizationName: "My Vault",
	organizationId: null,
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

log(input_filename) |

[ allVaults ] + [ myVault ] +
[
  .data.data[]
  | select(.name | tostring | test($search; "i"))
  | log([ .id, .name ])
  | alfred
] +
[ {
    title: "👈 Return to \($previousMenu) menu",
    arg: "👈"
  }
]
