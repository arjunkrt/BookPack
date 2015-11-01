CREATE OR REPLACE PACKAGE USER_AUTH AUTHID DEFINER AS
/* Version Control Comments Block

120.0 	ATHOMA12 	Creation

*/


PROCEDURE validateLogin(
					p_username 		IN 		athoma12.patrons.username%type,
					p_password 		IN 		athoma12.patrons.password_hash%type,
					p_patron_id		OUT 	athoma12.patrons.patron_id%type,
					p_patron_type 	OUT 	athoma12.patrons.patron_type%type,
					p_success		OUT 	INTEGER);


END USER_AUTH;
/