create or replace PACKAGE BODY RFuncCheckout AS
/* Version Control Comments Block

120.0 	pkattep 	Creation

*/
/*
pubCheckoutFunc1 performs the checkout and renew option provision.
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

Actual checkout is performed by pubCheckoutFunc2
*/

-- pubCheckoutFunc1 working for scenarios 1, 3 & 6 -- yet to be tested for 2, 4, 5
FUNCTION pubCheckoutFunc1(
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
END pubCheckoutFunc1;
					
FUNCTION pubCheckoutFunc2(
					r_rtype_id 		IN 			athoma12.books.rtype_id%type,
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_action		IN	 		NUMBER,
					r_h_or_e 		IN 			VARCHAR2,
					r_lib_of_preference IN	 	NUMBER,
					r_libname_of_pick_up OUT	athoma12.library.lib_name%type,
					r_no_in_waitlist OUT		NUMBER
					)
RETURN TIMESTAMP
IS
available_at_preferred_lib NUMBER(10) := 0;
rid_to_checkout NUMBER(10);
r_due_time TIMESTAMP DEFAULT NULL;
pub_is_reserved NUMBER(10) := 0;
borrow_id_nextval NUMBER(10) DEFAULT NULL;
pub_is_journal_or_conf NUMBER(10) := 0;
is_he_faculty NUMBER(10) := 0;
BEGIN
	SAVEPOINT beginFunc;

IF r_h_or_e = 'H' OR r_h_or_e = 'h' THEN

-- There a couple of calculations to be done when pub is a hard copy

	IF r_action = 1 THEN
	-- we have to perform the checkout operation
	
		--Checking if the the pub was available at the preferred library
		SELECT COUNT(*) INTO available_at_preferred_lib FROM athoma12.Resources
		WHERE rtype_id = r_rtype_id AND lib_id = r_lib_of_preference AND status = 'Available';
		
		IF available_at_preferred_lib > 0 THEN
			SELECT MIN(rid) INTO rid_to_checkout FROM athoma12.Resources
			WHERE rtype_id = r_rtype_id AND lib_id = r_lib_of_preference AND status = 'Available';
			
			SELECT L.lib_name INTO r_libname_of_pick_up FROM athoma12.library L, athoma12.Resources R
			WHERE R.rid = rid_to_checkout AND R.lib_id = L.lib_id;
		
		ELSE
			SELECT MIN(rid) INTO rid_to_checkout FROM athoma12.Resources
			WHERE rtype_id = r_rtype_id AND status = 'Available';
			
			SELECT L.lib_name INTO r_libname_of_pick_up FROM athoma12.library L, athoma12.Resources R
			WHERE R.rid = rid_to_checkout AND R.lib_id = L.lib_id;
		
		END IF;
	
	ELSIF r_action = 3  THEN
	-- Renew operation to be done
	-- Here, we take the return of the book and do re-checkout
		
		UPDATE pkattep.borrows
		SET return_time = CURRENT_TIMESTAMP
		WHERE patron_id = r_patron_id
			AND rid IN (SELECT rid from athoma12.Resources WHERE rtype_id = r_rtype_id);
	
	ELSIF r_action = 2 THEN
		
		INSERT INTO pkattep.waitlist VALUES (r_patron_id, r_rtype_id, CURRENT_TIMESTAMP, NULL);
		
		SELECT COUNT(*) INTO r_no_in_waitlist FROM pkattep.waitlist
		WHERE rtype_id = r_rtype_id;
	
	END IF;	
	
	IF r_action = 1 OR r_action = 3 THEN
	
				
			--Check if pub is journal or conference
			SELECT COUNT(*) INTO pub_is_journal_or_conf FROM athoma12.Resource_types
			WHERE (type = 'PJ' OR type = 'PJ') AND rtype_id = r_rtype_id;
			
			--Check if the pub is reserved
			IF pub_is_journal_or_conf = 0 THEN
			SELECT COUNT(*) INTO pub_is_reserved FROM athoma12.Books B, athoma12.Resource_types R
			WHERE R.type = 'PB' AND B.reserved = 1 AND B.rtype_id = R.rtype_id AND B.rtype_id = r_rtype_id;
			
				--Check if the patron is a faculty
			SELECT COUNT(*) INTO is_he_faculty FROM athoma12.patrons WHERE patron_type = 'F' AND patron_id = r_patron_id;
			END IF;
		
		borrow_id_nextval :=  BORROW_ID_SEQ.nextval;
		
		IF pub_is_journal_or_conf > 0 THEN
		INSERT INTO pkattep.borrows(borrow_id, patron_id, rid, checkout_time, due_time) VALUES (borrow_id_nextval, r_patron_id, rid_to_checkout, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + interval '12' hour);
		ELSIF pub_is_reserved > 0 THEN
		INSERT INTO pkattep.borrows(borrow_id, patron_id, rid, checkout_time, due_time) VALUES (borrow_id_nextval, r_patron_id, rid_to_checkout, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + interval '4' hour);
		ELSIF is_he_faculty > 0 THEN
		INSERT INTO pkattep.borrows(borrow_id, patron_id, rid, checkout_time, due_time) VALUES (borrow_id_nextval, r_patron_id, rid_to_checkout, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + interval '1' month);
		ELSE
		INSERT INTO pkattep.borrows(borrow_id, patron_id, rid, checkout_time, due_time) VALUES (borrow_id_nextval, r_patron_id, rid_to_checkout, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + 14);  --the default interval is days
		END IF;
    
		UPDATE pkattep.Resources
		SET status = 'CheckedOut'
		WHERE rid = rid_to_checkout;
		
		-- clearing the waitlist for the given rtype_id and patron_id after the checkout
		DELETE FROM pkattep.waitlist
		WHERE rtype_id = r_rtype_id AND patron_id = r_patron_id;
		
	END IF;
		
ELSE

	-- If the publication is an ecopy then checkout happens with the MIN(rid) for that rtype
			SELECT MIN(rid) INTO rid_to_checkout FROM athoma12.Resources
			WHERE rtype_id = r_rtype_id;
			
			borrow_id_nextval :=  BORROW_ID_SEQ.nextval;
			
			INSERT INTO pkattep.borrows VALUES (borrow_id_nextval, r_patron_id, rid_to_checkout, CURRENT_TIMESTAMP, NULL); 
			--putting due_date as NULL for epubs. This is imp to note and will be used in future calculations

END IF;
	
	COMMIT;
	return r_due_time;	
	
	EXCEPTION
	WHEN OTHERS THEN
	ROLLBACK TO beginFunc;
	
END pubCheckoutFunc2;

END RFuncCheckout;