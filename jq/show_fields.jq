include "bw";

# Format an item for Alfred
def alfred(f; v; a):
  {
    title: "\(f)",
    subtitle: "\(a)",
    arg: v,
    variables: {
	field: f
      }
  }
;

##################################################
# Main

.data.data[] |
  [
    # Common
    if .notes then alfred("Notes"; .notes; .notes) else empty end,

    # Login
    if .login.username then alfred("Username"; .login.username; .login.username) else empty end,
    if .login.password then alfred("Password"; .login.password; "********") else empty end,
    if .login.totp then alfred("TOTP Secret"; .login.totp; "********") else empty end,
    if .login.uris then [ .login.uris[] | alfred("URI"; .uri; .uri) ] else empty end,

    # Card
    if .card.number then alfred("Number"; .card.number; .card.number) else empty end,
    if .card.code then alfred("CCV"; .card.code; "***") else empty end,
    if .card.expMonth then alfred("Expiration Month"; .card.expMonth; .card.expMonth) else empty end,
    if .card.expYear then alfred("Expiration Year"; .card.expYear; .card.expYear) else empty end,

    # Identity
    if .identity.title then alfred("Title"; .identity.title; .identity.title) else empty end,
    if .identity.firstName then alfred("First"; .identity.firstName; .identity.firstName) else empty end,
    if .identity.middleName then alfred("Middle"; .identity.middleName; .identity.middleName) else empty end,
    if .identity.lastName then alfred("Last"; .identity.lastName; .identity.lastName) else empty end,
    if .identity.addres then alfred("Address"; .identity.addres; .identity.addres) else empty end,
    if .identity.city then alfred("City"; .identity.city; .identity.city) else empty end,
    if .identity.state then alfred("State"; .identity.state; .identity.state) else empty end,
    if .identity.postalCode then alfred("ZIP"; .identity.postalCode; .identity.postalCode) else empty end,
    if .identity.country then alfred("Country"; .identity.country; .identity.country) else empty end,
    if .identity.company then alfred("Company"; .identity.company; .identity.company) else empty end,
    if .identity.phone then alfred("Phone"; .identity.phone; .identity.phone) else empty end,
    if .identity.ssn then alfred("SSN"; .identity.ssn; "***-**-****") else empty end,
    if .identity.username then alfred("Username"; .identity.username; .identity.username) else empty end,
    if .identity.licenseNumber then alfred("License"; .identity.licenseNumber; "********") else empty end,
    if .identity.passportNumber then alfred("Passport"; .identity.passportNumber; .identity.passportNumber) else empty end
  ]

  +

  [
    try (.fields[] | if .type < 2 then alfred(.name; .value; if .type == 1 then "********" else .value end) else empty end)
    catch empty
  ]
