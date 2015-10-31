CREATE OR REPLACE PACKAGE RFUNC AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

FUNCTION is_in_waitlist(
					r_rtype_id 		IN			pkattep.books.rtype_id%type,
					)
RETURN NUMBER
IS
in_waitlist NUMBER := 0;
BEGIN
			SELECT COUNT(*)	INTO in_waitlist FROM pkattep.waitlist
			WHERE rtype_id = r_rtype_id;
			
			RETURN in_waitlist;
END is_in_waitlist;

FUNCTION put_in_waitlist(
					r_rtype_id 		IN			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type
					)
RETURN NUMBER
IS
no_waitlist NUMBER := 0;
in_waitlist NUMBER := 0;
BEGIN
			SELECT COUNT(*)	INTO in_waitlist FROM pkattep.waitlist
			WHERE patron_id = r_patron_id AND rtype_id = r_rtype_id;
			
			IF in_waitlist > 0 THEN
			SELECT no_in_waitlist INTO no_waitlist FROM pkattep.waitlist
			WHERE patron_id = r_patron_id AND rtype_id = r_rtype_id;
			END IF;
			
			RETURN no_waitlist;
END put_in_waitlist;

FUNCTION is_in_borrows(
					r_rtype_id 		IN			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type
					)
RETURN NUMBER
IS
in_borrows NUMBER := 0;
BEGIN
			SELECT COUNT(*)	INTO in_borrows
			FROM pkattep.borrows B, pkattep.Resources R
			WHERE B.patron_id = r_patron_id AND B.rtype_id = r_rtype_id
					AND B.rtype_id = R.rtype_id AND B.return_time IS NULL;
			
			RETURN in_borrows;
END is_in_borrows;
		
END RFUNC;
/