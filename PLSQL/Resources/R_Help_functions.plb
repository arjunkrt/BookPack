CREATE OR REPLACE PACKAGE R_HELP_FUNCTIONS AUTHID DEFINER AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

FUNCTION num_in_waitlist(
					r_rtype_id 		IN			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type
					) 
RETURN NUMBER;
IS

	

END num_in_waitlist;

END R_HELP_FUNCTIONS;
/