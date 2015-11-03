	create or replace PACKAGE BODY R_CHECKOUT AS
	/* Version Control Comments Block

	120.0 	pkattep 	Creation

	*/
	/*
	Validate_actions performs the checkout and renew option provision.
	r_action here has following mapping. These indicate what the user can
	do about the rtype_id he selected --
	1 - Checkout
	2 - Resource Request
	3 - Renew
	4 - Cannot renew
	5 - already requested, will be notified when available
	6 - Reserved, cannnot checkout

	Once we calculate the libraries at which the current r_rtype_id
	is available the r_lib_num will be coded as follows --
	0 - not available
	1 - available only in DH Hill
	2 - available only in Hunt
	3 - available in both libraries

	Actual checkout is performed by Checkout_or_waitlist
	*/

	-- Validate_actions working for scenarios 1, 3 AND 6 -- yet to be tested for 2, 4, 5
	FUNCTION Validate_actions(
						r_rtype_id 		IN			athoma12.books.rtype_id%type,
						r_patron_id		IN 			athoma12.patrons.patron_id%type
						) 
	RETURN NUMBER					
	IS
	r_action NUMBER(4);
	r_type athoma12.Resource_types.type%type;

	he_already_has_it NUMBER(10) := 0;
	he_already_has_requested_it NUMBER(10) := 0;
	another_has_requested_it NUMBER(10) := 0;
	pub_is_available NUMBER(10) := 0;
	pub_is_reserved NUMBER(10) := 0;
	he_can_have_this_reserved_pub NUMBER(10) := 0;
	is_he_faculty NUMBER(10):= 0;
	
	BEGIN	

					--Check if the same user has already checked out the same pub
					SELECT COUNT(*) INTO he_already_has_it FROM athoma12.borrows B, athoma12.Resources R
					WHERE R.rid = B.rid AND B.patron_id = r_patron_id AND R.rtype_id = r_rtype_id
							AND B.return_time IS NULL;

					--Check if the same user has already requested the same pub
					SELECT COUNT(*) INTO he_already_has_requested_it FROM athoma12.waitlist
					WHERE patron_id = r_patron_id AND rtype_id = r_rtype_id;

					--Check if the pub is avaiable				
					SELECT COUNT(*) INTO pub_is_available FROM athoma12.Resources
					WHERE status = 'Available' AND rtype_id = r_rtype_id;
					
					--------------------------------------------------------------------
					-------------  HANDLING RESERVED BOOKS    --------------------------
					--------------------------------------------------------------------
					--Check if the pub is reserved			
					SELECT COUNT(*) INTO pub_is_reserved FROM athoma12.Books B, athoma12.Resource_types R
					WHERE R.type = 'PB' AND B.reserved = 1 AND B.rtype_id = R.rtype_id AND B.rtype_id = r_rtype_id;
	        
	        				--Check if user is faculty
					SELECT COUNT(*) INTO is_he_faculty FROM athoma12.patrons WHERE patron_type = 'F' AND patron_id = r_patron_id;
					
					--Check if he can have this reserved pub; setting it to 1 if he can have it		
					IF pub_is_reserved = 1 THEN
					   IF (is_he_faculty = 0) THEN
							SELECT COUNT(*) INTO he_can_have_this_reserved_pub
							FROM athoma12.students S, athoma12.patrons P, athoma12.courses_taken CT, athoma12.courses C, athoma12.Books B
							WHERE P.patron_id = r_patron_id AND S.patron_id = P.patron_id
							 AND S.student_id = CT.student_id AND CT.course_id = C.course_id
							AND C.course_book_id = B.rtype_id AND B.rtype_id = r_rtype_id;
						ELSE
							--Check if he can have this reserved pub; setting it to 1 if he is a faculty
							SELECT COUNT(*) INTO he_can_have_this_reserved_pub
							FROM athoma12.patrons WHERE patron_type = 'F' AND patron_id = r_patron_id;
					    END IF;
					END IF;
					------------------------------------------------------------------------

		IF he_can_have_this_reserved_pub > 0 OR pub_is_reserved = 0 THEN				
			IF he_already_has_it > 0 THEN
			
			--Check if another user has requested it
					SELECT COUNT(*) INTO another_has_requested_it
					FROM athoma12.waitlist WHERE rtype_id = r_rtype_id;
				
					IF another_has_requested_it > 0 THEN
						r_action := 4;
					ELSE
						r_action := 3;
					END IF;
					
			ELSIF pub_is_available > 0 THEN
						r_action := 1;
						
			ELSIF he_already_has_requested_it > 0 THEN
						r_action := 5;
			ELSE 		r_action := 2;
			END IF;		
		ELSE
						r_action := 6;	
	    END IF;		
							
		RETURN r_action;			
	END Validate_actions;

----------------------------------------------------------------------------------------						
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
	          			borrow_id_nextval OUT NUMBER)

	IS
	available_at_preferred_lib NUMBER(10) := 0;
	rid_to_checkout NUMBER(10);
	pub_is_reserved NUMBER(10) := 0;
	pub_is_journal_or_conf NUMBER(10) := 0;
	is_he_faculty NUMBER(10) := 0;
	ecopy_available NUMBER(10):= 0;
	r_type athoma12.resource_types.type%type := NULL;
	
	he_already_has_requested_it NUMBER := 0;
	room_cam_checkout_time TIMESTAMP := NULL;
	room_return_cam_due_time TIMESTAMP := NULL;
	reservation_available NUMBER := 0;
	his_no_in_waitlist_c NUMBER:= 0;
	min_no_in_waitlist_c NUMBER:= 0;
	reservation_start_c TIMESTAMP;
	BEGIN
		SAVEPOINT beginFunc;
	  
	  --Assigning some default values to the OUT variables
	r_libname_of_pick_up := 0;
	r_no_in_waitlist := 0;
	r_due_time := TO_TIMESTAMP('4712-12-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF');
	borrow_id_nextval := 0;

	--finding the resource type of the rtype_id entered
	select type INTO r_type FROM athoma12.Resource_types WHERE rtype_id = r_rtype_id;
	
	dbms_output.put_line('r_type : '||r_type);

-----------------------------------------------------------------------------
IF r_type = 'C' THEN	

	dbms_output.put_line('C entered ');

	IF r_action = 1 THEN
		--valid inputs for this condition are r_patron_id, r_rtype_id, r_action
		--valid outputs is borrow_id_nextval, r_libname_of_pick_up
		dbms_output.put_line('C_r_action_1 entered ');
	
			--I am not checking if the camera is available here coz this API is called
			-- after listing only the available cameras
			--In the following queries are comparing just to see that he can check out the camera only
			--that friday of reservation
			SELECT COUNT(*)	INTO reservation_available
			FROM athoma12.waitlist
			WHERE rtype_id = r_rtype_id AND patron_id = r_patron_id
			AND reservation_start - interval '10' hour <= CURRENT_TIMESTAMP
				AND NOT (reservation_start + interval '14' hour < CURRENT_TIMESTAMP);
				
			SELECT MIN(reservation_start) INTO reservation_start_c				
			FROM athoma12.waitlist
			WHERE rtype_id = r_rtype_id AND patron_id = r_patron_id
			AND reservation_start - interval '10' hour <= CURRENT_TIMESTAMP
				AND NOT (reservation_start + interval '14' hour < CURRENT_TIMESTAMP);			
			
			SELECT MIN(no_in_waitlist) INTO	min_no_in_waitlist_c
			FROM athoma12.waitlist
			WHERE rtype_id = r_rtype_id
			AND reservation_start - interval '10' hour <= CURRENT_TIMESTAMP
				AND NOT (reservation_start + interval '14' hour < CURRENT_TIMESTAMP);				
	
			SELECT MIN(no_in_waitlist) INTO his_no_in_waitlist_c
			FROM athoma12.waitlist
			WHERE rtype_id = r_rtype_id AND patron_id = r_patron_id
			AND reservation_start - interval '10' hour <= CURRENT_TIMESTAMP
				AND NOT (reservation_start + interval '14' hour < CURRENT_TIMESTAMP);	
				
				dbms_output.put_line('reservation_available : '||reservation_available);
				dbms_output.put_line('min_no_in_waitlist_c : '||min_no_in_waitlist_c);
				dbms_output.put_line('his_no_in_waitlist_c : '||his_no_in_waitlist_c);
				dbms_output.put_line('reservation_start_c : '||reservation_start_c);
	
			
			IF reservation_available > 0 AND ((his_no_in_waitlist_c = min_no_in_waitlist_c
					AND reservation_start_c >= CURRENT_TIMESTAMP) OR
				(his_no_in_waitlist_c <> min_no_in_waitlist_c
					AND reservation_start_c < CURRENT_TIMESTAMP))
			THEN
			
			dbms_output.put_line('Complex IF block entered');
			
			SELECT MIN(R.rid)
			INTO rid_to_checkout
			FROM athoma12.Resources R, athoma12.waitlist W, athoma12.borrows B
			WHERE R.rtype_id = r_rtype_id AND W.patron_id = r_patron_id AND R.rtype_id = W.rtype_id
				--AND (B.rid <> R.rid OR B.due_time < CURRENT_TIMESTAMP)
				AND R.status = 'Available'
				AND W.reservation_start - interval '10' hour <= CURRENT_TIMESTAMP
				AND NOT (W.reservation_start + interval '14' hour < CURRENT_TIMESTAMP);
			
			--well.. following was hard to get..
			--The MAX was used to get one row. For some reason, may be due to joins
			--the same row was being printed multiple times
			SELECT MAX(W.reservation_start), MAX(W.reservation_end), MAX(L.lib_name)
			INTO room_cam_checkout_time, room_return_cam_due_time, r_libname_of_pick_up
			FROM athoma12.Resources R, athoma12.waitlist W, athoma12.borrows B, athoma12.library L
			WHERE W.rtype_id = r_rtype_id AND W.patron_id = r_patron_id AND R.rtype_id = W.rtype_id
				--AND (B.rid <> R.rid OR B.due_time < CURRENT_TIMESTAMP)
				AND R.status = 'Available'
				AND W.reservation_start - interval '10' hour <= CURRENT_TIMESTAMP
				AND NOT (W.reservation_start + interval '14' hour < CURRENT_TIMESTAMP)
				AND L.lib_id = R.lib_id;
			
			borrow_id_nextval :=  BORROW_ID_SEQ.nextval;
				
			INSERT INTO athoma12.borrows (borrow_id, patron_id, rid, checkout_time, due_time) VALUES
	      (borrow_id_nextval, r_patron_id, rid_to_checkout, room_cam_checkout_time, room_return_cam_due_time);
		   
		   	UPDATE athoma12.Resources
			SET status = 'CheckedOut'
			WHERE rid = rid_to_checkout;
		   
			/*-- clearing the waitlist for the given rtype_id and patron_id after the checkout
			--We may not want to delete from waitlist if we want to keep track of people
			--who did not manage to get the camera
			DELETE FROM athoma12.waitlist
			WHERE rtype_id = r_rtype_id AND patron_id = r_patron_id;
			 */ 
			END IF;	
	
	ELSIF r_action = 2 THEN
	
		dbms_output.put_line('C_r_action_2 entered ');
		--valid inputs for this condition are r_patron_id, r_rtype_id, r_action
		--valid output is r_no_in_waitlist
		
			--Check if the same user has already requested the same cam
			SELECT COUNT(*) INTO he_already_has_requested_it
			FROM athoma12.waitlist
			WHERE patron_id = r_patron_id AND rtype_id = r_rtype_id;
			
			IF he_already_has_requested_it > 0 THEN
			SELECT MIN(no_in_waitlist) INTO r_no_in_waitlist
			FROM athoma12.waitlist
			WHERE patron_id = r_patron_id AND rtype_id = r_rtype_id
				AND reservation_start > CURRENT_TIMESTAMP;
			
				
			dbms_output.put_line('he_already_has_requested_it : '|| he_already_has_requested_it);
			
			ELSIF he_already_has_requested_it = 0 THEN
			
      		select (TO_TIMESTAMP( NEXT_DAY (CURRENT_TIMESTAMP, 'FRI')) + INTERVAL '0 10' DAY TO HOUR)
			into room_cam_checkout_time from dual;
      		select (room_cam_checkout_time + INTERVAL '6 8' DAY to HOUR)
			into room_return_cam_due_time from dual;	

			dbms_output.put_line('room_cam_checkout_time : '|| room_cam_checkout_time);
			dbms_output.put_line('room_return_cam_due_time : '|| room_return_cam_due_time);

				SELECT COUNT(*) INTO r_no_in_waitlist FROM athoma12.waitlist
				WHERE rtype_id = r_rtype_id AND reservation_start > CURRENT_TIMESTAMP;
				
				IF r_no_in_waitlist = 0 THEN
				INSERT INTO athoma12.waitlist(patron_id, rtype_id, no_in_waitlist, reservation_start, reservation_end)
				VALUES(r_patron_id, r_rtype_id, 1, room_cam_checkout_time, room_return_cam_due_time);
				ELSE
				INSERT INTO athoma12.waitlist(patron_id, rtype_id, no_in_waitlist, reservation_start, reservation_end) 
				SELECT r_patron_id, r_rtype_id, max(no_in_waitlist)+1, room_cam_checkout_time, room_return_cam_due_time
				FROM athoma12.waitlist where rtype_id = r_rtype_id;
				END IF;
			
				r_no_in_waitlist := r_no_in_waitlist+1;
				r_due_time := room_cam_checkout_time;
				
				dbms_output.put_line('r_no_in_waitlist : '|| r_no_in_waitlist);	
			
			END IF;

		END IF;
	
-----------------------------------------------------------------------------
ELSIF r_type LIKE 'R_' THEN

	IF r_action = 1 THEN
				
			--valid inputs for this condition are r_patron_id, r_rtype_id, r_action
			--valid outputs is borrow_id_nextval
			
			dbms_output.put_line('R_action_1 entered');	
					
      		SELECT COUNT(*)
			INTO reservation_available
			FROM athoma12.waitlist
			WHERE rtype_id = r_rtype_id AND patron_id = r_patron_id AND reservation_start <= CURRENT_TIMESTAMP
			AND NOT (reservation_start > CURRENT_TIMESTAMP + interval '1' hour);
					
			dbms_output.put_line('reservation_available : '|| reservation_available);	
					
			SELECT MIN(R.rid), MAX(W.reservation_start), MAX(W.reservation_end)
			INTO rid_to_checkout, room_cam_checkout_time, room_return_cam_due_time
			FROM athoma12.Resources R, athoma12.waitlist W
			WHERE R.rtype_id = r_rtype_id AND W.patron_id = r_patron_id AND R.rtype_id = W.rtype_id AND W.reservation_start <= CURRENT_TIMESTAMP
					AND NOT (W.reservation_start > CURRENT_TIMESTAMP + interval '1' hour);
			
			IF reservation_available > 0	THEN
			borrow_id_nextval :=  BORROW_ID_SEQ.nextval;
				
			INSERT INTO athoma12.borrows (borrow_id, patron_id, rid, checkout_time, return_time) VALUES
	      (borrow_id_nextval, r_patron_id, rid_to_checkout, room_cam_checkout_time, room_return_cam_due_time);
		  	
			/* --If we want room cancellations to be logged somewhere we may not delete it from waitlist 
			-- clearing the waitlist for the given rtype_id and patron_id after the checkout
			DELETE FROM athoma12.waitlist
			WHERE rtype_id = r_rtype_id AND patron_id = r_patron_id
					AND (CURRENT_TIMESTAMP BETWEEN room_cam_checkout_time AND room_return_cam_due_time);
			  */
			END IF;
	
	ELSIF r_action = 2 THEN
	
			--valid inputs for this condition are r_patron_id, r_rtype_id, r_action, room_reservation_start, room_reservation_end
			--valid outputs is r_due_time
			--will return some reasonable value if the reservation took place
			--otherwise TO_TIMESTAMP('4712-12-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') will be returned
			--The above odd timestamp is set as default value for r_due_time
			--reservation may be cancelled in one common scenario where they try to reserve a room for
			--more than 3 hours
			
				IF (room_reservation_end - room_reservation_start <= interval '3' hour AND
					room_reservation_end - room_reservation_start > interval '0' hour) THEN
				INSERT INTO athoma12.waitlist(patron_id, rtype_id, no_in_waitlist, reservation_start, reservation_end)
				VALUES(r_patron_id, r_rtype_id, 0, room_reservation_start, room_reservation_end);
				
				select reservation_start + interval '1' hour into r_due_time
        		FROM athoma12.waitlist WHERE patron_id = r_patron_id AND rtype_id = r_rtype_id
        		AND reservation_start = room_reservation_start;
				
				END IF;			

	END IF;

-----------------------------------------------------------------------------
ELSIF r_type LIKE 'P_' THEN
	IF r_h_or_e = 'H' OR r_h_or_e = 'h' THEN

	  --dbms_output.put_line('IN --'||r_rtype_id||' '||r_patron_id||' '||r_action||' '||r_h_or_e||' '||r_lib_of_preference);
	-- There a couple of calculations to be done when pub is a hard copy

		IF r_action = 1 THEN
		-- we have to perform the checkout operation
	    --dbms_output.put_line(r_rtype_id||' '||r_patron_id||' '||r_action||' '||r_h_or_e||' '||r_lib_of_preference);
	    
			--Checking if the the pub was available at the preferred library
			SELECT COUNT(*) INTO available_at_preferred_lib FROM athoma12.Resources
			WHERE rtype_id = r_rtype_id AND lib_id = r_lib_of_preference AND status = 'Available';
	    	--dbms_output.put_line('available_at_preferred_lib :'||available_at_preferred_lib);
			
			IF available_at_preferred_lib > 0 THEN
				SELECT MIN(rid) INTO rid_to_checkout FROM athoma12.Resources
				WHERE rtype_id = r_rtype_id AND lib_id = r_lib_of_preference AND status = 'Available';
	      		--dbms_output.put_line('rid_to_checkout :'||rid_to_checkout);
	    	
				SELECT L.lib_name INTO r_libname_of_pick_up FROM athoma12.library L, athoma12.Resources R
				WHERE R.rid = rid_to_checkout AND R.lib_id = L.lib_id;
	      		--dbms_output.put_line('r_libname_of_pick_up :'||r_libname_of_pick_up);
	    
			ELSE
				SELECT MIN(rid) INTO rid_to_checkout FROM athoma12.Resources
				WHERE rtype_id = r_rtype_id AND status = 'Available';
	      		--dbms_output.put_line('rid_to_checkout :'||rid_to_checkout);
				
				SELECT L.lib_name INTO r_libname_of_pick_up FROM athoma12.library L, athoma12.Resources R
				WHERE R.rid = rid_to_checkout AND R.lib_id = L.lib_id;
			      --dbms_output.put_line('r_libname_of_pick_up :'||r_libname_of_pick_up);
			
			END IF;
		
		ELSIF r_action = 2 THEN
			
			SELECT COUNT(*) INTO r_no_in_waitlist FROM athoma12.waitlist
			WHERE rtype_id = r_rtype_id;
			IF r_no_in_waitlist = 0 THEN
				INSERT INTO athoma12.waitlist(patron_id, rtype_id, no_in_waitlist)
				VALUES(r_patron_id, r_rtype_id, 1);
			ELSE
				INSERT INTO athoma12.waitlist(patron_id, rtype_id, no_in_waitlist) 
				SELECT r_patron_id, r_rtype_id, max(no_in_waitlist)+1 FROM athoma12.waitlist where rtype_id = r_rtype_id;
			END IF;
			r_no_in_waitlist := r_no_in_waitlist+1;
				
		
		END IF;	
		
		IF r_action = 1 THEN
		
					
				--Check if pub is journal or conference
				SELECT COUNT(*) INTO pub_is_journal_or_conf FROM athoma12.Resource_types
				WHERE (type = 'PJ' OR type = 'PC') AND rtype_id = r_rtype_id;
				
				--Check if the pub is reserved
				IF pub_is_journal_or_conf = 0 THEN
				SELECT COUNT(*) INTO pub_is_reserved FROM athoma12.Books B, athoma12.Resource_types R
				WHERE R.type = 'PB' AND B.reserved = 1 AND B.rtype_id = R.rtype_id AND B.rtype_id = r_rtype_id;
				
					--Check if the patron is a faculty
				SELECT COUNT(*) INTO is_he_faculty FROM athoma12.patrons WHERE patron_type = 'F' AND patron_id = r_patron_id;
				END IF;
			
			borrow_id_nextval :=  BORROW_ID_SEQ.nextval;
			
			IF pub_is_journal_or_conf > 0 THEN
	    r_due_time := CURRENT_TIMESTAMP + interval '12' hour;
			INSERT INTO athoma12.borrows(borrow_id, patron_id, rid, checkout_time, due_time) VALUES
	    (borrow_id_nextval, r_patron_id, rid_to_checkout, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + interval '12' hour);
			ELSIF pub_is_reserved > 0 THEN
			r_due_time := CURRENT_TIMESTAMP + interval '4' hour;
	    INSERT INTO athoma12.borrows(borrow_id, patron_id, rid, checkout_time, due_time) VALUES
	    (borrow_id_nextval, r_patron_id, rid_to_checkout, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + interval '4' hour);
			ELSIF is_he_faculty > 0 THEN
	    r_due_time := CURRENT_TIMESTAMP + interval '1' month;
			INSERT INTO athoma12.borrows(borrow_id, patron_id, rid, checkout_time, due_time) VALUES
	    (borrow_id_nextval, r_patron_id, rid_to_checkout, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + interval '1' month);
			ELSE
	    r_due_time := CURRENT_TIMESTAMP + 14;
			INSERT INTO athoma12.borrows(borrow_id, patron_id, rid, checkout_time, due_time) VALUES
	    (borrow_id_nextval, r_patron_id, rid_to_checkout, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + 14);  --the default interval is days
			END IF;
	    
			UPDATE athoma12.Resources
			SET status = 'CheckedOut'
			WHERE rid = rid_to_checkout;
			
			-- clearing the waitlist for the given rtype_id and patron_id after the checkout
			DELETE FROM athoma12.waitlist
			WHERE rtype_id = r_rtype_id AND patron_id = r_patron_id;
			
		END IF;
-------------------------------------------------------------------------------			
	ELSE

	      --dbms_output.put_line('EE  '||r_rtype_id||' '||r_patron_id||' '||r_action||' '||r_h_or_e||' '||r_lib_of_preference);
		-- If the publication is an ecopy then checkout happens with the MIN(rid) for that rtype
		-- A non-zero borrow_id_nextval is returned if the ecopy was successfully checked out
		-- else zero will be returned if an ecopy is not availbale for the given rtype_id
		
			--valid inputs for this condition are r_patron_id, r_rtype_id, r_action, room_reservation_start, room_reservation_end
			--valid outputs is r_due_time
				
			SELECT COUNT(*) INTO ecopy_available FROM athoma12.ePublications WHERE rtype_id = r_rtype_id;
			
			IF ecopy_available > 0 THEN
				
				--here, borrow_id_nextval itself is used in order to make less changes to code
				--but actually eborrow_id sequence is used, so its basically eborrow_id
				borrow_id_nextval :=  EBORROW_ID_SEQ.nextval;
				
				INSERT INTO athoma12.eborrows (borrow_id, patron_id, rtype_id, checkout_time) VALUES
	      		(borrow_id_nextval, r_patron_id, r_rtype_id, CURRENT_TIMESTAMP); 
				--putting due_date as NULL for epubs. This is imp to note and will be used in future calculations
			END IF;

	END IF;
END IF;
-----------------------------------------------------------------------------		
		COMMIT;
	
		EXCEPTION
		WHEN OTHERS THEN
		ROLLBACK TO beginFunc;
		
	END Checkout_or_waitlist;
	
-----------------------------------------------------------------------------	

	PROCEDURE Renew(
					r_borrow_id 	IN			athoma12.borrows.borrow_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_due_time    	OUT   		TIMESTAMP
					) 
	IS
	r_rid athoma12.borrows.rid%type; 			
	r_rtype_id athoma12.resources.rtype_id%type;
	r_type athoma12.resource_types.type%type;
	pub_is_reserved NUMBER;
	is_he_faculty NUMBER;
	
	BEGIN	
		SAVEPOINT beginFunc;
    
	--Getting the rid, rtype_id, r_type for the given borrow_id and patron_id
	SELECT B.rid, R.rtype_id, RT.type INTO r_rid, r_rtype_id, r_type
	FROM athoma12.Borrows B, athoma12.Resources R, athoma12.Resource_types RT
	WHERE B.borrow_id = r_borrow_id AND B.patron_id = r_patron_id AND B.rid = R.rid AND R.rtype_id = RT.rtype_id;
	
	--Check if the pub is reserved			
	SELECT COUNT(*) INTO pub_is_reserved FROM athoma12.Books B, athoma12.Resource_types R
	WHERE R.type = 'PB' AND B.reserved = 1 AND B.rtype_id = R.rtype_id AND B.rtype_id = r_rtype_id;
	
	--Check if user is faculty
	SELECT COUNT(*) INTO is_he_faculty FROM athoma12.patrons WHERE patron_type = 'F' AND patron_id = r_patron_id;
	
	IF r_type = 'PJ' OR r_type = 'PC' THEN    	
    	r_due_time := CURRENT_TIMESTAMP + interval '12' hour;

	ELSIF r_type = 'PB' AND pub_is_reserved > 0 THEN
		r_due_time := CURRENT_TIMESTAMP + interval '4' hour;

	ELSIF r_type = 'PB' AND is_he_faculty > 0 THEN
    	r_due_time := CURRENT_TIMESTAMP + interval '1' month;

	ELSIF r_type = 'PB' THEN
    	r_due_time := CURRENT_TIMESTAMP + 14;

	END IF;
    
		UPDATE athoma12.borrows
		SET due_time = r_due_time
		WHERE patron_id = r_patron_id
		AND rid IN (SELECT rid from athoma12.Resources WHERE rtype_id = r_rtype_id);
		
		COMMIT;	
		
		EXCEPTION
		WHEN OTHERS THEN
		ROLLBACK TO beginFunc;
			
	END Renew;		
-----------------------------------------------------------------------------
/*
PROCEDURE Cancels_and_notifs(
	all_is_well OUT NUMBER
)
IS
BEGIN

	SAVEPOINT beginProc;

	UPDATE athoma12.waitlist
	SET reservation_status = 'Cancelled'
	WHERE reservation_start + interval '1' hour < CURRENT_TIMESTAMP
		AND rtype_id IN (SELECT rtype_id FROM athoma12.Resource_types WHERE type LIKE 'R_');

	UPDATE athoma12.waitlist
	SET reservation_status = 'Cancelled'
	WHERE reservation_start < CURRENT_TIMESTAMP
		AND no_in_waitlist = 1
		AND rtype_id IN (SELECT rtype_id FROM athoma12.Resource_types WHERE type LIKE 'C');
		
	UPDATE athoma12.waitlist
	SET reservation_status = 'Cancelled'
	WHERE reservation_start + interval '14' hour < CURRENT_TIMESTAMP
		AND no_in_waitlist <> 1
		AND rtype_id IN (SELECT rtype_id FROM athoma12.Resource_types WHERE type LIKE 'C');

		COMMIT;	
		
		EXCEPTION
		WHEN OTHERS THEN
		ROLLBACK TO beginFunc;

END Cancels_and_notifs;
*/

END R_CHECKOUT;
-----------------------------------------------------------------------------	
/