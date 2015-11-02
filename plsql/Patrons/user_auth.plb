CREATE OR REPLACE PACKAGE BODY USER_AUTH AS
/* Version Control Comments Block

120.0 	ATHOMA12 	Creation

*/



	PROCEDURE validateLogin(
						p_username 		IN 		athoma12.patrons.username%type,
						p_password 		IN 		athoma12.patrons.password_hash%type,
						p_patron_id 	OUT 	athoma12.patrons.patron_id%type,
						p_patron_type	OUT 	athoma12.patrons.patron_type%type,
						p_success 		OUT 	INTEGER) IS

	BEGIN
		p_success:= 0;
		BEGIN
			SELECT patron_id, patron_type, 1 INTO p_patron_id, p_patron_type, p_success
			FROM athoma12.patrons p
			WHERE p.username = p_username
			AND   p.password_hash = p_password
			AND p.acct_deact = 'N';

			p_success:= 1;
		EXCEPTION
			WHEN OTHERS THEN
				p_success := 0;
		END;

	END validateLogin;


END USER_AUTH;
/