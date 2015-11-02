CREATE OR REPLACE PACKAGE RFuncCheckout AUTHID DEFINER AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

FUNCTION pubCheckoutFunc1(
					r_rtype_id 		IN			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type
					) 
RETURN NUMBER;
/*					
FUNCTION pubCheckoutFunc2(
					r_rtype_id 		IN 			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_action		IN	 		NUMBER,
					r_h_or_e 		IN 			VARCHAR2,
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME,
					r_due_time		OUT 		DATETIME,
					r_lib_num		OUT			pkattep.library.lib_id%type
					);

FUNCTION roomCheckoutFunc1(
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_no_occupants	IN			NUMBER,
					r_libid			IN 			pkattep.publications_authors.aid%type
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME
					);
					
FUNCTION roomCheckoutFunc2(
					r_rtype_id 		IN 			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME
					);	
					
FUNCTION camCheckoutFunc(
					r_rtype_id 		IN 		pkattep.conf_Funceedings.rtype_id%type,
					r_checkout_time IN	 	DATETIME,
					r_borrowed_waitlisted 	OUT		NUMBER,
					r_due_time 		OUT		DATETIME
					);						
*/
END RFuncCheckout;
/