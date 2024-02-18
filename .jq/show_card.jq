include "bw";

def month:
  .card | "\(.expMonth) "
	    + if .expMonth == "1" then "(Jan)"
	      elif .expMonth == "2" then "(Feb)"
	      elif .expMonth == "3" then "(Mar)"
	      elif .expMonth == "4" then "(Apr)"
	      elif .expMonth == "5" then "(May)"
	      elif .expMonth == "6" then "(Jun)"
	      elif .expMonth == "7" then "(Jul)"
	      elif .expMonth == "8" then "(Aug)"
	      elif .expMonth == "9" then "(Sep)"
	      elif .expMonth == "10" then "(Oct)"
	      elif .expMonth == "11" then "(Nov)"
	      elif .expMonth == "12" then "(Dec)"
	      else "(Smarch)" end
;

.data
  | field("Name"; .card.cardholderName; ":\t\t")
     + field("Number"; .card.number; ":\t")
     + if .card.expMonth then field("Month"; month; ":\t\t") else "" end
     + field("Year"; .card.expYear; ":\t\t")
     + field("CCV"; .card.code; ":\t\t")
     + common
