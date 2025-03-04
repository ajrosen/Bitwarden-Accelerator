include "bw";

.data
  | field("Name:"; .name; "\t\t")
     + field("Public Key"; .sshKey.publicKey; ":\t")
     + field("keyFingerprint"; .sshKey.keyFingerprint; ":\t")
     + common
