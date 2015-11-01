CREATE OR REPLACE PACKAGE RFuncCheckout2 AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

FUNCTION roomReserveFunc1(
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_no_occupants	IN			NUMBER,
					r_libid			IN 			pkattep.publications_authors.aid%type
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME
					);
					
FUNCTION roomReserveFunc2(
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
END RFuncCheckout2;
/