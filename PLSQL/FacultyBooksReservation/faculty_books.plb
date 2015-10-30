CREATE OR REPLACE PACKAGE BODY FACULTY_BOOKS AS
/* Version Control Comments Block

120.0 	ATHOMA12 	Creation

*/

	PROCEDURE updateBookReservation(
						p_rtype_id 			IN 			ATHOMA12.books.rtype_id%type,
						p_r_or_unr 			IN 			VARCHAR2) IS
	BEGIN
	SAVEPOINT beginProc;
		IF p_r_or_unr = 'R' THEN
			UPDATE athoma12.books SET reserved = 1
			WHERE rtype_id = p_rtype_id;
		ELSE
			UPDATE athoma12.books SET reserved = 0
			WHERE rtype_id = p_rtype_id;
		END IF;
	COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK TO beginProc;

	END updateBookReservation;




END FACULTY_BOOKS;
/
