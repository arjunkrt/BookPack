CREATE OR REPLACE PACKAGE BODY NOTIFICATION_MGMT AS
/* Version Control Comments Block

120.0 	ATHOMA12 	Creation

*/

	PROCEDURE createNotificationGrpParams(
							p_grp_attribute_number 	IN 	athoma12.notification_grp_params.grp_attribute_number%type,
							p_notification_id 	IN 		athoma12.notification_patrons.notification_id%type,
							p_attribute0		IN		athoma12.notification_grp_params.attribute_value%type DEFAULT NULL,
							p_attribute1		IN		athoma12.notification_grp_params.attribute_value%type DEFAULT NULL,
							p_attribute2		IN		athoma12.notification_grp_params.attribute_value%type DEFAULT NULL,
							p_attribute3		IN		athoma12.notification_grp_params.attribute_value%type DEFAULT NULL,
							p_attribute4		IN		athoma12.notification_grp_params.attribute_value%type DEFAULT NULL,
							p_attribute5		IN		athoma12.notification_grp_params.attribute_value%type DEFAULT NULL,
							p_attribute6		IN		athoma12.notification_grp_params.attribute_value%type DEFAULT NULL,
							p_attribute7		IN		athoma12.notification_grp_params.attribute_value%type DEFAULT NULL,
							p_attribute8		IN		athoma12.notification_grp_params.attribute_value%type DEFAULT NULL,
							p_attribute9		IN		athoma12.notification_grp_params.attribute_value%type DEFAULT NULL,
							p_ind_attr_count	IN 		NUMBER) IS
		l_ind_attribute_number NUMBER(20);
	BEGIN
	/*
		SELECT NVL(MAX(ind_attribute_number),-1)+1 INTO l_ind_attribute_number FROM notification_grp_params 
		WHERE notification_id = p_notification_id
		AND grp_attribute_number = p_grp_attribute_number;

		WHILE l_ind_attribute_number < p_ind_attr_count LOOP
		
			EXECUTE IMMEDIATE 'INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(grp_attribute_number, notification_id, ind_attribute_number, attribute_value)
			VALUES (p_grp_attribute_number, p_notification_id, l_ind_attribute_number, p_attribute' || mod(l_ind_attribute_number,10) ||')';

		END LOOP;
	*/
		l_ind_attribute_number := 1;
		if p_attribute0 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(grp_attribute_number, notification_id, ind_attribute_number, attribute_value)
		VALUES (p_grp_attribute_number, p_notification_id, 1, p_attribute0);
		end if;

		if p_attribute1 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(grp_attribute_number, notification_id, ind_attribute_number, attribute_value)
		VALUES (p_grp_attribute_number, p_notification_id, 2, p_attribute1);
		end if;
		
		if p_attribute2 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(grp_attribute_number, notification_id, ind_attribute_number, attribute_value)
		VALUES (p_grp_attribute_number, p_notification_id, 3, p_attribute2);
		end if;
		
		if p_attribute3 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(grp_attribute_number, notification_id, ind_attribute_number, attribute_value)
		VALUES (p_grp_attribute_number, p_notification_id, 4, p_attribute3);
		end if;
		
		if p_attribute4 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(grp_attribute_number, notification_id, ind_attribute_number, attribute_value)
		VALUES (p_grp_attribute_number, p_notification_id, 5, p_attribute4);
		end if;
		
		if p_attribute5 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(grp_attribute_number, notification_id, ind_attribute_number, attribute_value)
		VALUES (p_grp_attribute_number, p_notification_id, 6, p_attribute5);
		end if;
		
		if p_attribute6 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(grp_attribute_number, notification_id, ind_attribute_number, attribute_value)
		VALUES (p_grp_attribute_number, p_notification_id, 7, p_attribute6);
		end if;
		
		if p_attribute7 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(grp_attribute_number, notification_id, ind_attribute_number, attribute_value)
		VALUES (p_grp_attribute_number, p_notification_id, 8, p_attribute7);
		end if;
		
		if p_attribute8 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(grp_attribute_number, notification_id, ind_attribute_number, attribute_value)
		VALUES (p_grp_attribute_number, p_notification_id, 9, p_attribute8);
		end if;
		
		if p_attribute9 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(grp_attribute_number, notification_id, ind_attribute_number, attribute_value)
		VALUES (p_grp_attribute_number, p_notification_id, 10, p_attribute9);
		end if;
	END createNotificationGrpParams;

PROCEDURE createNotification(
						p_notification_id 	OUT 	athoma12.notification_patrons.notification_id%type,
						p_template_name 	IN 		athoma12.notification_patrons.template_name%type,
						p_patron_id 		IN 		athoma12.notification_patrons.patron_id%type,
						p_attribute0		IN		athoma12.notification_attributes.attribute_value%type DEFAULT NULL,
						p_attribute1		IN		athoma12.notification_attributes.attribute_value%type DEFAULT NULL,
						p_attribute2		IN		athoma12.notification_attributes.attribute_value%type DEFAULT NULL,
						p_attribute3		IN		athoma12.notification_attributes.attribute_value%type DEFAULT NULL,
						p_attribute4		IN		athoma12.notification_attributes.attribute_value%type DEFAULT NULL,
						p_attribute5		IN		athoma12.notification_attributes.attribute_value%type DEFAULT NULL,
						p_attribute6		IN		athoma12.notification_attributes.attribute_value%type DEFAULT NULL,
						p_attribute7		IN		athoma12.notification_attributes.attribute_value%type DEFAULT NULL,
						p_attribute8		IN		athoma12.notification_attributes.attribute_value%type DEFAULT NULL,
						p_attribute9		IN		athoma12.notification_attributes.attribute_value%type DEFAULT NULL,
						p_notif_sent		IN		athoma12.notification_patrons.notif_sent%type DEFAULT NULL,
						p_notif_seen 		IN 		athoma12.notification_patrons.notif_seen%type DEFAULT NULL,
						p_attr_count 		IN 		NUMBER) IS
		l_attribute_number NUMBER(20);
	BEGIN
		p_notification_id := NOTIFICATIONS_SEQ.nextval;
		
		INSERT INTO ATHOMA12.NOTIFICATION_PATRONS(notification_id, template_name, patron_id, notif_sent, notif_seen)
		VALUES (p_notification_id, p_template_name, p_patron_id, nvl(p_notif_sent, 'N'), nvl(p_notif_seen, 'N'));

/*
		SELECT NVL(MAX(attribute_number),-1)+1 INTO l_attribute_number FROM notification_attributes
		WHERE notification_id = p_notification_id;

		WHILE l_attribute_number < p_attr_count LOOP
		
			EXECUTE IMMEDIATE 'INSERT INTO ATHOMA12.NOTIFICATION_ATTRIBUTES(notification_id, attribute_number, attribute_value)
			VALUES ('||p_notification_id||', '||l_attribute_number||', 'p_attribute' || mod(l_attribute_number,10) || ')';

		END LOOP;
*/		
		if p_attribute0 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_ATTRIBUTES(notification_id, attribute_number, attribute_value)
		VALUES (p_notification_id, 1, p_attribute0);
		end if;

		if p_attribute1 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_ATTRIBUTES(notification_id, attribute_number, attribute_value)
		VALUES (p_notification_id, 2, p_attribute1);
		end if;
		
		if p_attribute2 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_ATTRIBUTES(notification_id, attribute_number, attribute_value)
		VALUES (p_notification_id, 3, p_attribute2);
		end if;
		
		if p_attribute3 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_ATTRIBUTES(notification_id, attribute_number, attribute_value)
		VALUES (p_notification_id, 4, p_attribute3);
		end if;
		
		if p_attribute4 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_ATTRIBUTES(notification_id, attribute_number, attribute_value)
		VALUES (p_notification_id, 5, p_attribute4);
		end if;
		
		if p_attribute5 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_ATTRIBUTES(notification_id, attribute_number, attribute_value)
		VALUES (p_notification_id, 6, p_attribute5);
		end if;
		
		if p_attribute6 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_ATTRIBUTES(notification_id, attribute_number, attribute_value)
		VALUES (p_notification_id, 7, p_attribute6);
		end if;
		
		if p_attribute7 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_ATTRIBUTES(notification_id, attribute_number, attribute_value)
		VALUES (p_notification_id, 8, p_attribute7);
		end if;
		
		if p_attribute8 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_ATTRIBUTES(notification_id, attribute_number, attribute_value)
		VALUES (p_notification_id, 9, p_attribute8);
		end if;
		
		if p_attribute9 is not null THEN
		INSERT INTO ATHOMA12.NOTIFICATION_ATTRIBUTES(notification_id, attribute_number, attribute_value)
		VALUES (p_notification_id, 10, p_attribute9);
		end if;
	END createNotification;
/*
	PROCEDURE updateNotifWGroupParams(
							p_notification_id 	IN 		athoma12.notification_patrons.notification_id%type,
							p_grp_attribute1 	IN OUT 	athoma12.notification_grp_params.notif_grp_param_id%type,
							p_grp_attribute2 	IN 		athoma12.notification_grp_params.notif_grp_param_id%type DEFAULT NULL) IS 
	BEGIN
		update athoma12.notification_patrons set 
			grp_attribute1 = p_grp_attribute1,
			grp_attribute2 = p_grp_attribute2
		WHERE
			notification_id = p_notification_id;
	--Calling block handles exception
	END updateNotifWGroupParams;
*/
	PROCEDURE updateNotificationSeen(
							p_notification_id 	OUT 	athoma12.notification_patrons.notification_id%type,
							p_notif_seen 		IN 		athoma12.notification_patrons.notif_seen%type) IS
	BEGIN
		update athoma12.notification_patrons set 
			notif_seen = p_notif_seen
		WHERE
			notification_id = p_notification_id;
	END updateNotificationSeen;

	PROCEDURE updateNotificationSent(
							p_notification_id 	OUT 	athoma12.notification_patrons.notification_id%type,
							p_notif_sent 		IN 		athoma12.notification_patrons.notif_sent%type) IS
	BEGIN
		update athoma12.notification_patrons set 
			notif_sent = p_notif_sent
		WHERE
			notification_id = p_notification_id;
	END updateNotificationSent;


	PROCEDURE runFirstReminder IS
		l_notification_id athoma12.notification_patrons.notification_id%type;
		CURSOR findPatrons IS
			select p.patron_id, p.first_name, p.last_name, p.department, p.username from patrons p
				where exists(select 1 from user_checkout_summary ucs where due_time between systimestamp  and systimestamp+interval '3' DAY
				and ucs.patron_id = p.patron_id
				and not exists (select 1 from notification_grp_params ngp, notification_patrons np where 
                np.template_name = 'FIRST_REMINDER' and ngp.grp_attribute_number = 1 and ngp.ind_attribute_number=1
                and to_number(ngp.attribute_value) = ucs.borrow_id)
				);


		CURSOR findBorrowRecs(l_patron_id NUMBER) IS
			select * from user_checkout_summary ucs where due_time between systimestamp  and systimestamp+interval '3' DAY and patron_id = l_patron_id
			and not exists (select 1 from notification_grp_params ngp, notification_patrons np where 
                np.template_name = 'FIRST_REMINDER' and ngp.grp_attribute_number = 1 and ngp.ind_attribute_number=1
                and to_number(ngp.attribute_value) = ucs.borrow_id)
				;
	BEGIN
		SAVEPOINT beginProc;
		FOR patronsRec in findPatrons
		LOOP
			
			athoma12.notification_mgmt.createNotification(
							p_notification_id => l_notification_id,
							p_template_name => 'FIRST_REMINDER',
							p_patron_id => patronsRec.patron_id,
							p_attribute0 => patronsRec.first_name,
							p_attr_count => 1);


			FOR borrowsRec in findBorrowRecs(patronsRec.patron_id)
			LOOP
				athoma12.notification_mgmt.createNotificationGrpParams(
							p_grp_attribute_number => 1,
							p_notification_id => l_notification_id,
							p_attribute0 => borrowsRec.borrow_id,
							p_attribute1 => borrowsRec.description,
							p_attribute2 => borrowsRec.due_time,
							p_ind_attr_count => 2);
			END LOOP;
		END LOOP;

	END runFirstReminder;

	PROCEDURE runSecondReminder IS
		l_notification_id athoma12.notification_patrons.notification_id%type;
		CURSOR findPatrons IS
			select p.patron_id, p.first_name, p.last_name, p.department, p.username from patrons p
				where exists(select 1 from user_checkout_summary ucs where due_time between systimestamp  and systimestamp+interval '1' DAY
				and ucs.patron_id = p.patron_id
				and not exists (select 1 from notification_grp_params ngp, notification_patrons np where 
                np.template_name = 'DUE_SECOND_REMINDER' and ngp.grp_attribute_number = 1 and ngp.ind_attribute_number=1
                and to_number(ngp.attribute_value) = ucs.borrow_id)
				);


		CURSOR findBorrowRecs(l_patron_id NUMBER) IS
			select * from user_checkout_summary ucs where due_time between systimestamp  and systimestamp+interval '1' DAY and patron_id = l_patron_id
			and not exists (select 1 from notification_grp_params ngp, notification_patrons np where 
                np.template_name = 'SECOND_DUE_REMINDER' and ngp.grp_attribute_number = 1 and ngp.ind_attribute_number=1
                and to_number(ngp.attribute_value) = ucs.borrow_id)
				;
	BEGIN
		SAVEPOINT beginProc;
		FOR patronsRec in findPatrons
		LOOP
			
			athoma12.notification_mgmt.createNotification(
							p_notification_id => l_notification_id,
							p_template_name => 'DUE_SECOND_REMINDER',
							p_patron_id => patronsRec.patron_id,
							p_attribute0 => patronsRec.first_name,
							p_attr_count => 1);


			FOR borrowsRec in findBorrowRecs(patronsRec.patron_id)
			LOOP
				athoma12.notification_mgmt.createNotificationGrpParams(
							p_grp_attribute_number => 1,
							p_notification_id => l_notification_id,
							p_attribute0 => borrowsRec.borrow_id,
							p_attribute1 => borrowsRec.description,
							p_attribute2 => borrowsRec.due_time,
							p_ind_attr_count => 2);
			END LOOP;
		END LOOP;

	END runSecondReminder;
END NOTIFICATION_MGMT;
/