CREATE OR REPLACE PACKAGE FACULTY_BOOKS AUTHID DEFINER AS
/* Version Control Comments Block

120.0 	ATHOMA12 	Creation

*/

PROCEDURE updateBookReservation(
					p_rtype_id 			IN 			ATHOMA12.books.rtype_id%type,
					p_r_or_unr 			IN 			VARCHAR2

);



END FACULTY_BOOKS;
/