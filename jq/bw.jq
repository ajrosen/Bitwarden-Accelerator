module { name: "Bitwarden Accelerator", version: "1.0" };

def log(s):
  if $ENV.DEBUG == "1" then debug(s) end
;

# Get an item's common fields
def baseFields:
  {
    organizationId,
    collectionIds,
    folderId,
    type,
    name,
    notes,
    favorite,
    reprompt,
  }
;

def loginFields:
  .login | {
    username,
    password,
    totp,
    uris,
  }
;

# Get an item's type
def itemType:
  . | if .type == 1 then "Login"
      elif .type == 2 then "Secure Note" 
      elif .type == 3 then "Card"
      elif .type == 5 then "SSH key"
      else "Identity" end
;

# Choose icon for item
def icon(a):
  if a.type == 1 then "login.png"
  elif a.type == 2 then "sn.png"
  elif a.type == 3 then a.card.brand + ".png"
  elif a.type == 4 then "identity.png"
  elif a.type == 5 then "sshkey.png"
  else "identity.png" end
;

# Prepare a field for display dialog
# k(ey):s(eperator)v(alue)
def field(k; v; s):
  if v then "\(k)\(s)\(v)\n" else "" end
;

# Show custom fields
def fields:
  .fields[] | field(.name + ":"; .value; "\t\t")
;

# List attachments
def attachments:
  .attachments[] | field(.fileName + ":"; .sizeName; "\t\t")
;

# Extra fields common to all types
def common:
  . | if $org != "" then field("Organization"; $org // "My Vault"; ":") else "" end
  + if (.fields | length) > 0 then "\([ fields ] | add)" else "" end
  + if (.attachments | length) > 0 then "\([ attachments ] | add)" else "" end
  + field("Notes"; .notes; ":\t\t")
  + "\n"
  + if .id then field("ID"; .id; ":\t\t\t") else "" end
  + if .login then field("Type"; "Login"; ":\t\t") else "" end
  + if .card then field("Type"; "Card"; ":\t\t") else "" end
  + if .identity then field("Type"; "Identity"; ":\t\t") else "" end
  + if .sshKey then field("Type"; "SSH Key"; ":\t\t") else "" end
  + if .revisionDate then field("Last modified"; .revisionDate; ":\t") else "" end
;
