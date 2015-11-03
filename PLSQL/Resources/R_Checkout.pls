CREATE OR REPLACE PACKAGE R_CHECKOUT AUTHID DEFINER AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

FUNCTION Validate_actions(
					r_rtype_id 		IN			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type
					) 
RETURN NUMBER;
			
PROCEDURE Checkout_or_waitlist(
						r_rtype_id 		IN 			athoma12.books.rtype_id%type,
						r_patron_id		IN 			athoma12.patrons.patron_id%type,
						r_action		  IN	 		NUMBER,
						r_h_or_e 		  IN 			VARCHAR2,
						r_lib_of_preference IN	 	NUMBER,
						room_reservation_start IN	TIMESTAMP,
						room_reservation_end IN		TIMESTAMP,
						r_libname_of_pick_up OUT	athoma12.library.lib_name%type,
						r_no_in_waitlist OUT		NUMBER,
	          			r_due_time    OUT   TIMESTAMP,
	          			borrow_id_nextval OUT NUMBER);
					
PROCEDURE Renew(
					r_borrow_id 	IN			athoma12.borrows.borrow_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_due_time    	OUT   		TIMESTAMP
					) ;

PROCEDURE Cancels_and_notifs;
					

END R_CHECKOUT;
/

/*
-------------------------------------------------------------------------------------
Checkout_or_waitlist API for camera

for reservation -- r_action = 2 --

PROCEDURE Checkout_or_waitlist(
						r_rtype_id 			IN 		 -----------  	REQUIRED
						r_patron_id			IN 		 -----------	REQUIRED
						r_action		  	IN	 	 -----------	REQUIRED
						r_h_or_e 		  	IN 		 -----------	NA
						r_lib_of_preference IN	 	 -----------	NA
						room_reservation_start 	IN	 -----------	NA
						room_reservation_end 	IN	 -----------	NA
						r_libname_of_pick_up 	OUT	 -----------	NA
						r_no_in_waitlist 		OUT  -----------	VALID
	          			r_due_time    			OUT  -----------	VALID
	          			borrow_id_nextval 		OUT  -----------	NA
						  );
					
for checkout -- r_action = 1 --

PROCEDURE Checkout_or_waitlist(
						r_rtype_id 			IN 		 -----------  	REQUIRED
						r_patron_id			IN 		 -----------	REQUIRED
						r_action		  	IN	 	 -----------	REQUIRED
						r_h_or_e 		  	IN 		 -----------	NA
						r_lib_of_preference IN	 	 -----------	NA
						room_reservation_start 	IN	 -----------	NA
						room_reservation_end 	IN	 -----------	NA
						r_libname_of_pick_up 	OUT	 -----------	VALID
						r_no_in_waitlist 		OUT  -----------	NA
	          			r_due_time    			OUT  -----------	NA
	          			borrow_id_nextval 		OUT  -----------	VALID
						  );
						  
-------------------------------------------------------------------------------------						  
Checkout_or_waitlist API for rooms

for reservation -- r_action = 2 --

PROCEDURE Checkout_or_waitlist(
						r_rtype_id 			IN 		 -----------  	REQUIRED
						r_patron_id			IN 		 -----------	REQUIRED
						r_action		  	IN	 	 -----------	REQUIRED
						r_h_or_e 		  	IN 		 -----------	NA
						r_lib_of_preference IN	 	 -----------	NA
						room_reservation_start 	IN	 -----------	NA
						room_reservation_end 	IN	 -----------	NA
						r_libname_of_pick_up 	OUT	 -----------	NA
						r_no_in_waitlist 		OUT  -----------	NA
	          			r_due_time    			OUT  -----------	NA
	          			borrow_id_nextval 		OUT  -----------	VALID
						  );
					
for checkout -- r_action = 1 --

PROCEDURE Checkout_or_waitlist(
						r_rtype_id 			IN 		 -----------  	REQUIRED
						r_patron_id			IN 		 -----------	REQUIRED
						r_action		  	IN	 	 -----------	REQUIRED
						r_h_or_e 		  	IN 		 -----------	NA
						r_lib_of_preference IN	 	 -----------	NA
						room_reservation_start 	IN	 -----------	REQUIRED
						room_reservation_end 	IN	 -----------	REQUIRED
						r_libname_of_pick_up 	OUT	 -----------	NA
						r_no_in_waitlist 		OUT  -----------	NA
	          			r_due_time    			OUT  -----------	VALID
	          			borrow_id_nextval 		OUT  -----------	NA
						  );

-------------------------------------------------------------------------------------
Checkout_or_waitlist API for publications

for waitisting -- r_action = 2 --

PROCEDURE Checkout_or_waitlist(
						r_rtype_id 			IN 		 -----------  	REQUIRED
						r_patron_id			IN 		 -----------	REQUIRED
						r_action		  	IN	 	 -----------	REQUIRED
						r_h_or_e 		  	IN 		 -----------	REQUIRED
						r_lib_of_preference IN	 	 -----------	REQUIRED
						room_reservation_start 	IN	 -----------	NA
						room_reservation_end 	IN	 -----------	NA
						r_libname_of_pick_up 	OUT	 -----------	NA
						r_no_in_waitlist 		OUT  -----------	VALID
	          			r_due_time    			OUT  -----------	NA
	          			borrow_id_nextval 		OUT  -----------	VALID
						  );
					
for checkout -- r_action = 1 --

PROCEDURE Checkout_or_waitlist(
						r_rtype_id 			IN 		 -----------  	REQUIRED
						r_patron_id			IN 		 -----------	REQUIRED
						r_action		  	IN	 	 -----------	REQUIRED
						r_h_or_e 		  	IN 		 -----------	REQUIRED
						r_lib_of_preference IN	 	 -----------	REQUIRED
						room_reservation_start 	IN	 -----------	NA
						room_reservation_end 	IN	 -----------	NA
						r_libname_of_pick_up 	OUT	 -----------	VALID
						r_no_in_waitlist 		OUT  -----------	NA
	          			r_due_time    			OUT  -----------	VALID
	          			borrow_id_nextval 		OUT  -----------	VALID
						  );
						  
-------------------------------------------------------------------------------------
Checkout_or_waitlist API for epublications

for checking out epublications

PROCEDURE Checkout_or_waitlist(
						r_rtype_id 			IN 		 -----------  	REQUIRED
						r_patron_id			IN 		 -----------	REQUIRED
						r_action		  	IN	 	 -----------	NA
						r_h_or_e 		  	IN 		 -----------	REQUIRED
						r_lib_of_preference IN	 	 -----------	NA
						room_reservation_start 	IN	 -----------	NA
						room_reservation_end 	IN	 -----------	NA
						r_libname_of_pick_up 	OUT	 -----------	NA
						r_no_in_waitlist 		OUT  -----------	NA
	          			r_due_time    			OUT  -----------	NA
	          			borrow_id_nextval 		OUT  -----------	VALID
						  );
						  
-------------------------------------------------------------------------------------

*/