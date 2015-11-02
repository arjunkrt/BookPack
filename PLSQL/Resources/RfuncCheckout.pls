CREATE OR REPLACE PACKAGE RFuncCheckout AUTHID DEFINER AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

FUNCTION pubCheckoutFunc1(
					r_rtype_id 		IN			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type
					) 
RETURN NUMBER;
			
FUNCTION pubCheckoutFunc2(
					r_rtype_id 		IN 			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_action		IN	 		NUMBER,
					r_h_or_e 		IN 			VARCHAR2,
					r_lib_of_preference IN	 	NUMBER,
					r_libname_of_pick_up OUT	athoma12.library.lib_name%type,
					r_no_in_waitlist OUT		NUMBER
					)
RETURN TIMESTAMP;

END RFUNCCHECKOUT;
/