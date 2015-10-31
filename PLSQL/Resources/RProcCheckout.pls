CREATE OR REPLACE PACKAGE RProcCheckout AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

PROCEDURE pubCheckoutProc1(
					r_rtype_id 		IN			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_title			OUT 		pkattep.publications.title%type,
					r_identifier	OUT 		pkattep.books.isbn%type,
					r_edition 		OUT 		pkattep.books.edition%type,
					r_publishers 	OUT 		pkattep.books.publishers%type,
					r_year 		 	OUT 		pkattep.publications.year%type,
					r_action		OUT 		NUMBER
					);
/*					
PROCEDURE pubCheckoutProc2(
					r_rtype_id 		IN 			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_action		IN	 		NUMBER,
					r_h_or_e 		IN 			VARCHAR2,
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME,
					r_due_time		OUT 		DATETIME,
					r_lib_num		OUT			pkattep.library.lib_id%type
					);

PROCEDURE roomCheckoutProc1(
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_no_occupants	IN			NUMBER,
					r_libid			IN 			pkattep.publications_authors.aid%type
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME
					);
					
PROCEDURE roomCheckoutProc2(
					r_rtype_id 		IN 			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME
					);	
					
PROCEDURE camCheckoutProc(
					r_rtype_id 		IN 		pkattep.conf_proceedings.rtype_id%type,
					r_checkout_time IN	 	DATETIME,
					r_borrowed_waitlisted 	OUT		NUMBER,
					r_due_time 		OUT		DATETIME
					);						
*/
END RProcCheckout;
/