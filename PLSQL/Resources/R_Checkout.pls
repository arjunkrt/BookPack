CREATE OR REPLACE PACKAGE R_CHECKOUT AUTHID DEFINER AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

FUNCTION Validate_actions(
					r_rtype_id 		IN			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type
					) 
RETURN NUMBER;
			
PROCEDURE Checkout_or_waitlist(
					r_rtype_id 		IN 			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_action		IN	 		NUMBER,
					r_h_or_e 		IN 			VARCHAR2,
					r_lib_of_preference IN	 	NUMBER,
					r_libname_of_pick_up OUT	athoma12.library.lib_name%type,
					r_no_in_waitlist OUT		NUMBER,
					r_due_time    OUT   TIMESTAMP,
          			borrow_id_nextval OUT NUMBER
					);
					
	PROCEDURE Renew(
					r_borrow_id 	IN			athoma12.borrows.borrow_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_due_time    	OUT   		TIMESTAMP
					) ;

END R_CHECKOUT;
/