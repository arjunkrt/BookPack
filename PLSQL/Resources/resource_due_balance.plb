CREATE OR REPLACE PACKAGE BODY resource_due_balance AS
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


procedure get_total_balance(
            p_patron_id 	IN		ATHOMA12.USER_CHECKOUT_SUMMARY.patron_id%type,
            l_total_balance OUT NUMBER)IS
            l_rid			 		ATHOMA12.USER_CHECKOUT_SUMMARY.rid%type;
            l_due_balance NUMBER;
            l_type        ATHOMA12.USER_CHECKOUT_SUMMARY.TYPE%type;
            l_borrow_id   ATHOMA12.USER_CHECKOUT_SUMMARY.BORROW_ID%type;
            l_overdue_time interval day to second := null;
           cursor c1 is select RID,TYPE,BORROW_ID from ATHOMA12.USER_CHECKOUT_SUMMARY where PATRON_ID=p_patron_id and RETURN_TIME is null;	
            BEGIN
            l_total_balance := 0;
FOR resType in c1
   LOOP
      l_rid := resType.rid;
      l_type := resType.type;
      l_borrow_id := resType.borrow_id;
      if l_type = 'PB' OR l_type='C' then
      l_due_balance := get_due_balance(l_borrow_id);
      l_total_balance := l_total_balance +l_due_balance;
      ELSE
      l_due_balance := 0;
      l_total_balance  := 0;
      END if;
   END LOOP;
END get_total_balance;


function get_due_balance(
            p_borrow_id        IN    ATHOMA12.USER_CHECKOUT_SUMMARY.BORROW_ID%type)
            RETURN NUMBER
            IS --,
            l_due_balance NUMBER(20);
            l_overdue_time interval day to second;
            l_return_time   ATHOMA12.USER_CHECKOUT_SUMMARY.RETURN_TIME%type;
            l_due_time   ATHOMA12.USER_CHECKOUT_SUMMARY.DUE_TIME%type;
            l_time_overdue number := 0;
            l_type ATHOMA12.USER_CHECKOUT_SUMMARY.TYPE%type;
	BEGIN
  l_overdue_time := null;
  l_due_balance := 0;
  SELECT DUE_TIME,type into l_due_time,l_type from ATHOMA12.USER_CHECKOUT_SUMMARY where BORROW_ID=p_borrow_id;
  l_return_time := current_timestamp;
  l_overdue_time := l_return_time - l_due_time;
l_time_overdue := (extract (day from (l_overdue_time)) * 24) +
(extract (hour from (l_overdue_time))) +
(extract (minute from (l_overdue_time))/60) +
(extract (second from (l_overdue_time))/3600);
          if l_type ='C' then   
          l_due_balance := floor(l_time_overdue);
          ELSE
          l_time_overdue := l_time_overdue/24;
          l_due_balance := 2*floor(l_time_overdue);
         END if;
         
         if l_due_balance < 0 then
         l_due_balance := 0;
         end if;
      RETURN l_due_balance;
      
END get_due_balance;
END resource_due_balance;
/
