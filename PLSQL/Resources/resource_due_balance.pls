CREATE OR REPLACE PACKAGE resource_due_balance AUTHID CURRENT_USER AS
/* Version Control Comments Block
 	AGARG9 	Creation
*/
procedure get_total_balance(
            p_patron_id 	IN		ATHOMA12.USER_CHECKOUT_SUMMARY.patron_id%type,
            l_total_balance OUT NUMBER);
            
function get_due_balance(
            p_borrow_id        IN    ATHOMA12.USER_CHECKOUT_SUMMARY.BORROW_ID%type);
            RETURN NUMBER;
