CREATE OR REPLACE PACKAGE USER_AUTH AUTHID CURRENT_USER AS
/* Version Control Comments Block

120.0 	ATHOMA12 	Creation

*/


FUNCTION validateLogin(
					p_username 		IN 		athoma12.patrons.username%type,
					p_password 		IN 		athoma12.patrons.password_hash%type)
					RETURN INTEGER;


END USER_AUTH;
/