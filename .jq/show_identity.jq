include "bw";

.data
  | field("Name:"; .name; "\t\t")
     + field("Title"; .identity.title; ":\t\t")
     + field("First"; .identity.firstName; ":\t\t")
     + field("Middle"; .identity.middleName; ":\t\t")
     + field("Last"; .identity.lastName; ":\t\t")
     + field("Address"; .identity.address1; ":\t")
     + field("\t\t"; .identity.address2; "\t")
     + field("\t\t"; .identity.address3; "\t")
     + field("City"; .identity.city; ":\t\t")
     + field("State"; .identity.state; ":\t\t")
     + field("ZIP"; .identity.postalCode; ":\t\t\t")
     + field("Country"; .identity.country; ":\t")
     + field("Company"; .identity.company; ":\t")
     + field("Phone"; .identity.phone; ":\t\t")
     + field("SSN"; .identity.ssn; ":\t\t")
     + field("Username"; .identity.username; ":\t")
     + field("License"; .identity.licenseNumber; ":\t")
     + field("Passport"; .identity.passportNumber; ":\t")
     + common
