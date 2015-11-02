create or replace PACKAGE BODY RFuncCheckout2 AS
/* Version Control Comments Block

120.0 	pkattep 	Creation

*/
/*
Convetion used in roomReserveFunc1 for r_conf_study (IN)
conference room - 1
study room - 2
*/

FUNCTION roomReserveFunc1(
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_no_occupants	IN			NUMBER,
					r_lib_id		IN 			athoma12.publications_authors.aid%type
					r_conf_study	IN			NUMBER,
					r_reservation_start IN	 	DATETIME,
					r_reservation_stop 	IN		DATETIME
					) IS
BEGIN
				
END roomReserveFunc1;
/*					
FUNCTION roomReserveFunc2(
					r_rtype_id 		IN 			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_reservation_start IN	 	DATETIME,
					r_reservation_stop 	IN		DATETIME
					) IS
BEGIN
				
END roomReserveFunc2;
					
FUNCTION camCheckoutFunc(
					r_rtype_id 		IN 		athoma12.conf_Funceedings.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_checkout_time IN	 	DATETIME,
					r_borrowed_waitlisted 	OUT		NUMBER,
					r_due_time 		OUT		DATETIME
					) IS
					
END camCheckoutFunc;				
*/
END RFUNCCHECKOUT2;
/