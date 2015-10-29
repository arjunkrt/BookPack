CREATE OR REPLACE PACKAGE RPROC AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

PROCEDURE pubCheckoutProc1(
					r_rtype_id 		IN			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_h_or_e 		IN 			VARCHAR2,
					r_title			OUT 		pkattep.publications.title%type,
					r_identifier	OUT 		pkattep.books.isbn%type,
					r_edition 		OUT 		pkattep.books.edition%type,
					r_publishers 	OUT 		pkattep.books.publishers%type,
					r_year 		 	OUT 		pkattep.publications.year%type,
					r_action		OUT 		NUMBER,
					r_lib_num		OUT			pkattep.library.lib_id%type,
					) IS
rtype_id_table INTEGER(4) := 0;
count_available INTEGER(4) := 0;
in_borrows INTEGER(4) := 0;
in_waitlist INTEGER(4) := 0;
BEGIN	

--Identifying which table the rtype_id belongs to

				SELECT COUNT(*) INTO rtype_id_table FROM pkattep.Books
				WHERE EXISTS (SELECT rtype_id FROM pkattep.Books WHERE rtype_id = r_rtype_id);
				IF rtype_id_table > 0 THEN rtype_id_table := 1 END IF;
								
				IF rtype_id_table == 0 THEN
				SELECT COUNT(*) INTO rtype_id_table FROM pkattep.journals
				WHERE EXISTS (SELECT rtype_id FROM pkattep.journals WHERE rtype_id = r_rtype_id);
				IF rtype_id_table > 0 THEN rtype_id_table := 2 END IF;
				END IF;
					
				IF rtype_id_table == 0 THEN
				SELECT COUNT(*) INTO rtype_id_table FROM pkattep.Conf_Proceedings
				WHERE EXISTS (SELECT rtype_id FROM pkattep.Conf_Proceedings WHERE rtype_id = r_rtype_id);
				IF rtype_id_table > 0 THEN rtype_id_table := 3 END IF;
				END IF;
				
--Put the details from the identified table into OUT variables

				IF rtype_id_table == 1 THEN
				SELECT P.title, B.ISBN, B.edition, B.publishers, P.year
				INTO r_title, r_identifier, r_edition, r_publishers, r_year
				FROM pkattep.Books B, pkattep.publications P
				WHERE B.rtype_id = P.rtype_id
				END IF;
				
				IF rtype_id_table == 2 THEN
				SELECT P.title, J.ISSN, NULL, NULL, NULL
				INTO r_title, r_identifier, r_edition, r_publishers, r_year
				FROM pkattep.journals J, pkattep.publications P
				WHERE J.rtype_id = P.rtype_id
				END IF;
					
				IF rtype_id_table == 3 THEN
				SELECT P.title, C.ISSN, NULL, NULL, NULL
				INTO r_title, r_identifier, r_edition, r_publishers, r_year
				FROM pkattep.Conf_Proceedings C, pkattep.publications P
				WHERE C.rtype_id = P.rtype_id
				END IF;

-- is_in_borrows function which returns if the patron already has the publication
-- if he is there 1 is returned, 0 otherwise

				in_borrows := is_in_borrows(r_rtype_id, r_patron_id);
				in_waitlist := is_in_waitlist(r_rtype_id);
				
--To determine which action to perform and find lib_num
				
				SELECT COUNT(*) INTO count_available FROM Resources R
				WHERE R.rtype_id = r_rtype_id AND R.status = 'Available';

				IF count_available == 0 THEN r_action := 4;
				ELSIF count_available > 0 THEN r_action := 1;
				ELSIF c
									
END pubCheckoutProc1;
					
PROCEDURE pubCheckoutProc2(
					r_rtype_id 		IN 			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_action		IN	 		NUMBER,
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME,
					r_due_time		OUT 		DATETIME
					) IS
BEGIN

-- is_in_waitlist function which returns the number of the patron in the queue
-- if he is there, 0 otherwise

				no_in_waitlist := is_in_waitlist(r_rtype_id, r_patron_id);
				
END pubCheckoutProc2;

PROCEDURE roomCheckoutProc1(
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_no_occupants	IN			NUMBER,
					r_libid			IN 			pkattep.publications_authors.aid%type
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME
					) IS
BEGIN
				
END roomCheckoutProc1;
					
PROCEDURE roomCheckoutProc2(
					r_rtype_id 		IN 			pkattep.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_checkout_time IN	 		DATETIME,
--					r_return_time 	IN			DATETIME
					) IS
BEGIN
				
END roomCheckoutProc2;
					
PROCEDURE camCheckoutProc(
					r_rtype_id 		IN 		pkattep.conf_proceedings.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_checkout_time IN	 	DATETIME,
					r_borrowed_waitlisted 	OUT		NUMBER,
					r_due_time 		OUT		DATETIME
					) IS
					
END camCheckoutProc;				

END RPROC;
/