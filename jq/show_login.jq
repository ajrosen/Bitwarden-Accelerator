include "bw";

def uris:
  .login.uris[] | .uri
;

.data
  | field("Name:"; .name; "\t\t")
     + field("Username:"; .login.username; "\t")
     + field("Password:"; .login.password; "\t")
     + field("TOTP:"; .login.totp; "\t\t")
     + if (.login.uris | length) > 0 then field("URIs:"; ([ uris ] | join("\n\t\t\t\t")); "\t\t") else "" end
     + common
