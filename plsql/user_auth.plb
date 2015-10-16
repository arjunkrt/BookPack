CREATE OR REPLACE PACKAGE BODY USER_AUTH AS
/* Version Control Comments Block

120.0 	ATHOMA12 	Creation

*/



	FUNCTION validateLogin(
						p_username 		IN 		athoma12.patrons.username%type,
						p_password 		IN 		athoma12.patrons.password_hash%type)
						RETURN INTEGER AS

		l_fetched INTEGER := 0;
	BEGIN
		BEGIN
			SELECT 1 INTO l_fetched
			FROM athoma12.patrons p
			WHERE p.username = p_username
			AND   p.password_hash = p_password;

			l_fetched := 1;
		EXCEPTION
			WHEN OTHERS THEN
				l_fetched := 0;
		END;

		RETURN l_fetched;
	END validateLogin;


END USER_AUTH;
/