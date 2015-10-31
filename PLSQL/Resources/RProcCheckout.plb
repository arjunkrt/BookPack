CREATE OR REPLACE PACKAGE RProcCheckout AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/
/*
pubCheckoutProc1 performs the checkout and renew option provision.
r_action here has following mapping. These indicate what the user can
do about the rtype_id he selected --
1 - Checkout
2 - Resource Request
3 - Renew
4 - Cannot renew
5 - already requested, will be notified when available
6 - Reserved, cannnot checkout

Actual checkout is performed by pubCheckoutProc2
*/

PROCEDURE pubCheckoutProc1(
					r_rtype_id 		IN			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_h_or_e 		IN 			VARCHAR2,
					r_title			OUT 		pkattep.publications.title%type,
					r_identifier	OUT 		pkattep.books.isbn%type,
					r_edition 		OUT 		pkattep.books.edition%type,
					r_publishers 	OUT 		pkattep.books.publishers%type,
					r_year 		 	OUT 		pkattep.publications.year%type,
					r_action		OUT 		NUMBER,
					r_lib_num		OUT			pkattep.library.lib_id%type,
					) IS
r_type pkattep.Resource_types.type%type;

he_already_has_it INTEGER(4) := 0;
he_already_has_requested_it INTEGER(4) := 0;
another_has_requested_it INTEGER(4) := 0;
pub_requested_is_available INTEGER(4) := 0;
pub_is_reserved INTEGER(4) := 0;
he_can_have_this_reserved_pub INTEGER(4) := 0;

BEGIN	

	SAVEPOINT beginProc;

--Check if the same user has checked out the same book

				SELECT COUNT(*) INTO he_already_has_it FROM pkattep.borrows B, pkattep.Resources R
				WHERE R.rid = B.rid AND B.patron_id = r_patron_id AND R.rtype_id = r_rtype_id
						AND B.return_time >= CURRENT_TIMESTAMP;

				SELECT COUNT(*) INTO he_already_has_requested_it FROM pkattep.waitlist
				WHERE patron_id = r_patron_id AND rtype_id = r_rtype_id;
				
				SELECT COUNT(*) INTO pub_requested_is_available FROM pkattep.Resources
				WHERE status = 'Available' AND rtype_id = r_rtype_id;
				
				SELECT 		

		IF he_already_has_it > 0 THEN
		
		--Check if another user has requested it
				SELECT COUNT(*) INTO another_has_requested_it
				FROM pkattep.waitlist WHERE rtype_id = r_rtype_id;
				
				IF another_has_requested_it > 0 THEN
					r_action = 4;
				ELSE
					r_action = 3;
					
		ELSIF he_already_has_requested_it > 0 THEN
					r_action = 5;
					
		ELSIF pub_requested_is_available > 0 THEN
					r_action = 1;
		ELSE 		r_action = 0;
		END IF;		
				
				
--Identifying which table the rtype_id belongs to

				SELECT type INTO r_type FROM pkattep.RESOURCE_TYPES WHERE rtype_id = r_rtype_id;
				
--Put the details from the identified table into OUT variables

		IF r_type == 'PB' THEN
	    	SELECT P.title, B.ISBN, B.edition, B.publishers, P.year
			INTO r_title, r_identifier, r_edition, r_publishers, r_year
			FROM pkattep.publications P, pkattep.Books B
			WHERE rtype_id = r_rtype_id;
	  
		ELSIF r_type == 'PJ' THEN
	    	SELECT P.title, J.ISSN, NULL, NULL, P.year
			INTO r_title, r_identifier, r_edition, r_publishers, r_year
			FROM pkattep.publications P, pkattep.Journals J
			WHERE rtype_id = r_rtype_id; 
	
		ELSIF r_type == 'PC' THEN
	    	SELECT P.title, J., NULL, NULL, P.year
			INTO r_title, r_identifier, r_edition, r_publishers, r_year
			FROM pkattep.publications P, pkattep.Conf_Proceedings C
			WHERE rtype_id = r_rtype_id;

		ELSE 
			r_title = NULL;
			r_identifier = NULL;
			r_edition = NULL;
			r_publishers = NULL;
			r_year = NULL;
				
		END IF;
		
-- Finding in which libraries that rtype is available


	COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
	ROLLBACK TO beginProc;
									
END pubCheckoutProc1;
					
PROCEDURE pubCheckoutProc2(
					r_rtype_id 		IN 			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_action		IN	 		NUMBER,
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME,
					r_due_time		OUT 		DATETIME
					) IS
BEGIN

-- is_in_waitlist function which returns the number of the patron in the queue
-- if he is there, 0 otherwise

				no_in_waitlist := is_in_waitlist(r_rtype_id, r_patron_id);
				
END pubCheckoutProc2;

PROCEDURE roomCheckoutProc1(
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_no_occupants	IN			NUMBER,
					r_libid			IN 			pkattep.publications_authors.aid%type
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME
					) IS
BEGIN
				
END roomCheckoutProc1;
					
PROCEDURE roomCheckoutProc2(
					r_rtype_id 		IN 			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME
					) IS
BEGIN
				
END roomCheckoutProc2;
					
PROCEDURE camCheckoutProc(
					r_rtype_id 		IN 		pkattep.conf_proceedings.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_checkout_time IN	 	DATETIME,
					r_borrowed_waitlisted 	OUT		NUMBER,
					r_due_time 		OUT		DATETIME
					) IS
					
END camCheckoutProc;				

END RProcCheckout;
/