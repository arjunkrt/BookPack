CREATE OR REPLACE PACKAGE resource_due_balance AS
/* Version Control Comments Block
120.0 	AGARG9 	Creation
*/
/*
Resource_due_balanace performs following actions.
1. Calculate number of hours a resource is delayed from its due date.
	a. If user has already returned the resource(book/camera) difference of return time and due time will be calculated
	b. If user still owns that resource, then difference of current time and due time will be calculated and displayed to user.
2. If resource is of book type 2$ fine will be imposed per day
	a. If resource is overdue by more than 90 days, a new row will be added to hold table with user's username and resource it hold and amount due. 
3. If resource is of camera type, fine of 1$/hour is imposed on user.
*/


procedure update_duedate(
            b_patron_id 	IN		borrows.patron_id%type,
						b_rid			  IN 		borrows.rid%type,
            b_return_time        OUT    BORROWS.RETURN_TIME%type,
            b_hours_overdue OUT BORROWS.HOURS_OVERDUE%type) IS
            --PRAGMA AUTONOMOUS_TRANSACTION;
        b_checkout_time BORROWS.CHECKOUT_TIME%type;
        b_due_time  BORROWS.DUE_TIME%type;
        b_borrow_id  BORROWS.BORROW_ID%type;
	BEGIN
    SELECT MAX(BORROW_ID) into b_borrow_id from BORROWS where patron_id=b_patron_id and rid=b_rid;
  SELECT CHECKOUT_TIME,DUE_TIME,RETURN_TIME into b_checkout_time,b_due_time,b_return_time from BORROWS where BORROW_ID=b_borrow_id;
  if b_return_time is NULL then
  b_return_time := current_timestamp;
  end if;
 SELECT EXTRACT (DAY    FROM (b_return_time-b_due_time))*24+
             EXTRACT (HOUR   FROM (b_return_time-b_due_time))+
             EXTRACT (MINUTE FROM (b_return_time-b_due_time))/60+
             EXTRACT (SECOND FROM (b_return_time-b_due_time))/3600 DELTA INTO b_hours_overdue FROM BORROWS where BORROW_ID=b_borrow_id;
             commit;
  UPDATE BORROWS SET HOURS_OVERDUE=b_hours_overdue where BORROW_ID=b_borrow_id;
END update_duedate; 
/