CREATE OR REPLACE PACKAGE BODY RProcCheckout AS
/* Version Control Comments Block

120.0 	pkattep 	Creation

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

Once we calculate the libraries at which the current r_rtype_id
is available the r_lib_num will be coded as follows --
0 - not available
1 - available only in DH Hill
2 - available only in Hunt
3 - available in both libraries

Actual checkout is performed by pubCheckoutProc2
*/

PROCEDURE pubCheckoutProc1(
					r_rtype_id 		IN			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_title			OUT 		athoma12.publications.title%type,
					r_identifier	OUT 		athoma12.books.isbn%type,
					r_edition 		OUT 		athoma12.books.edition%type,
					r_publishers 	OUT 		athoma12.books.publishers%type,
					r_year 		 	OUT 		athoma12.publications.year%type,
					r_action		OUT 		NUMBER
					) IS
r_type athoma12.Resource_types.type%type;

he_already_has_it NUMBER(10) := 0;
he_already_has_requested_it NUMBER(10) := 0;
another_has_requested_it NUMBER(10) := 0;
pub_is_available NUMBER(10) := 0;
pub_is_reserved NUMBER(10) := 0;
he_can_have_this_reserved_pub NUMBER(10) := 0;

BEGIN	

	SAVEPOINT beginProc;

				--Check if the same user has already checked out the same pub
				SELECT COUNT(*) INTO he_already_has_it FROM athoma12.borrows B, athoma12.Resources R
				WHERE R.rid = B.rid AND B.patron_id = r_patron_id AND R.rtype_id = r_rtype_id
						AND B.return_time >= CURRENT_TIMESTAMP;

				--Check if the same user has already requested the same pub
				SELECT COUNT(*) INTO he_already_has_requested_it FROM athoma12.waitlist
				WHERE patron_id = r_patron_id AND rtype_id = r_rtype_id;

				--Check if the pub is avaiable				
				SELECT COUNT(*) INTO pub_is_available FROM athoma12.Resources
				WHERE status = 'Available' AND rtype_id = r_rtype_id;
				
				--------------------------------------------------------------------
				-------------  HANDLING RESERVED BOOKS    --------------------------
				--------------------------------------------------------------------
				--Check if the pub is reserved			
				SELECT COUNT(*) INTO pub_is_reserved FROM athoma12.Books B, athoma12.Resource_types R
				WHERE R.type = 'PB' AND B.reserved = 1 AND B.rtype_id = R.rtype_id AND B.rtype_id = r_rtype_id;
				
				--Check if he can have this reserved pub; setting it to 1 if he can have it		
				SELECT COUNT(*) INTO he_can_have_this_reserved_pub
				FROM athoma12.students S, athoma12.patrons P, athoma12.courses_taken CT, athoma12.courses C, athoma12.Books B
				WHERE pub_is_reserved = 1 AND P.patron_id = r_patron_id AND S.patron_id = P.patron_id
					 AND S.student_id = CT.student_id AND CT.course_id = C.course_id
					AND C.course_book_id = B.rtype_id AND B.rtype_id = r_rtype_id;
					
				--Check if he can have this reserved pub; setting it to 1 if he is a faculty
				SELECT COUNT(*) INTO he_can_have_this_reserved_pub
				FROM athoma12.patrons WHERE patron_type = 'F' AND patron_id = r_patron_id;
				------------------------------------------------------------------------

	IF he_can_have_this_reserved_pub > 0 OR pub_is_reserved = 0 THEN
		IF he_already_has_it > 0 THEN
		
		--Check if another user has requested it
				SELECT COUNT(*) INTO another_has_requested_it
				FROM athoma12.waitlist WHERE rtype_id = r_rtype_id;
				
				IF another_has_requested_it > 0 THEN
					r_action := 4;
				ELSE
					r_action := 3;
				END IF;
					
		ELSIF pub_is_available > 0 THEN
					r_action := 1;
					
		ELSIF he_already_has_requested_it > 0 THEN
					r_action := 5;
		ELSE 		r_action := 2;
		END IF;		
	ELSE
					r_action := 6;	
    END IF;		
				
--Identifying which table the rtype_id belongs to

				SELECT type INTO r_type FROM athoma12.RESOURCE_TYPES WHERE rtype_id = r_rtype_id;
				
--Put the details from the identified table into OUT variables

		IF r_type = 'PB' THEN
	    	SELECT P.title, B.ISBN, B.edition, B.publishers, P.year
			INTO r_title, r_identifier, r_edition, r_publishers, r_year
			FROM athoma12.publications P, athoma12.Books B
			WHERE P.rtype_id = r_rtype_id AND P.rtype_id = B.rtype_id;
	  
		ELSIF r_type = 'PJ' THEN
	    	SELECT P.title, J.ISSN, NULL, NULL, P.year
			INTO r_title, r_identifier, r_edition, r_publishers, r_year
			FROM athoma12.publications P, athoma12.Journals J
			WHERE P.rtype_id = r_rtype_id AND P.rtype_id = J.rtype_id;
	
		ELSIF r_type = 'PC' THEN
	    	SELECT P.title, C.conf_no, NULL, NULL, P.year
			INTO r_title, r_identifier, r_edition, r_publishers, r_year
			FROM athoma12.publications P, athoma12.Conf_Proceedings C
			WHERE P.rtype_id = r_rtype_id AND P.rtype_id = C.rtype_id;

		ELSE 
			r_title := NULL;
			r_identifier := NULL;
			r_edition := NULL;
			r_publishers := NULL;
			r_year := NULL;
				
		END IF;
		
	COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
	ROLLBACK TO beginProc;
									
END pubCheckoutProc1;
/*					
PROCEDURE pubCheckoutProc2(
					r_rtype_id 		IN 			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_action		IN	 		NUMBER,
					r_h_or_e 		IN 			VARCHAR2,
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME,
					r_due_time		OUT 		DATETIME,
					r_lib_num		OUT			athoma12.library.lib_id%type
					) IS
BEGIN

	SAVEPOINT beginProc;

-- is_in_waitlist function which returns the NUMBER(10) of the patron in the queue
-- if he is there, 0 otherwise

				no_in_waitlist := is_in_waitlist(r_rtype_id, r_patron_id);
				
				
				
				-- Finding in which libraries that rtype is available
-- The Following data is hard-coded for the 2 libraries we have
-- This will have to change if more libraries are included

	IF pub_is_available > 0 THEN
	SELECT COUNT(DISTINCT lib_id) INTO r_lib_num FROM athoma12.Resources R, athoma12.library L
	WHERE R.rtype_id = r_rtype_id AND R.lib_id = L.lib_id;
	
		IF r_lib_num = 1 THEN
		
	
	ELSE 
	r_lib_num = 0;
	
	COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
	ROLLBACK TO beginProc;
				
END pubCheckoutProc2;

PROCEDURE roomCheckoutProc1(
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_no_occupants	IN			NUMBER,
					r_libid			IN 			athoma12.publications_authors.aid%type
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME
					) IS
BEGIN
				
END roomCheckoutProc1;
					
PROCEDURE roomCheckoutProc2(
					r_rtype_id 		IN 			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME
					) IS
BEGIN
				
END roomCheckoutProc2;
					
PROCEDURE camCheckoutProc(
					r_rtype_id 		IN 		athoma12.conf_proceedings.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_checkout_time IN	 	DATETIME,
					r_borrowed_waitlisted 	OUT		NUMBER,
					r_due_time 		OUT		DATETIME
					) IS
					
END camCheckoutProc;				
*/
END RProcCheckout;
/