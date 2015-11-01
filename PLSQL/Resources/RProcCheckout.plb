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