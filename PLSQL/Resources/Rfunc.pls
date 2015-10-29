CREATE OR REPLACE PACKAGE RFUNC AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

FUNCTION is_in_waitlist(
					r_rtype_id 		IN			pkattep.books.rtype_id%type,
					r_h_or_e 		IN 			VARCHAR2,
					r_title			OUT 		pkattep.publications.title%type,
					r_isbn 			OUT 		pkattep.books.isbn%type,
					r_edition 		OUT 		pkattep.books.edition%type,
					r_publishers 	OUT 		pkattep.books.publishers%type,
					r_year 		 	OUT 		pkattep.publications.year%type,
					r_action		OUT 		NUMBER,
					r_lib_num		OUT			pkattep.library.lib_id%type,
					)
RETURN NUMBER;
					
END RFUNC;
/