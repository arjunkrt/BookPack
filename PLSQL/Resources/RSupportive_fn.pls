CREATE OR REPLACE PACKAGE RFUNC AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

FUNCTION is_in_waitlist(
					r_rtype_id 		IN			pkattep.books.rtype_id%type,
					)
RETURN NUMBER;

FUNCTION is_in_borrows(
					r_rtype_id 		IN			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type
					)
RETURN NUMBER;
					
END RFUNC;
/