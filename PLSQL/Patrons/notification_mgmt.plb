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

END NOTIFICATION_MGMT;
/