CREATE OR REPLACE PACKAGE BODY NOTIFICATION_MGMT AS
/* Version Control Comments Block

120.0 	ATHOMA12 	Creation

*/

	PROCEDURE createNotificationGrpParams(
						p_notif_grp_param_id IN OUT athoma12.notification_grp_params.notif_grp_param_id%type,
						p_notification_id 	IN 		athoma12.notification_patrons.notification_id%type,
						p_attribute1		IN		athoma12.notification_grp_params.attribute1%type DEFAULT NULL,
						p_attribute2		IN		athoma12.notification_grp_params.attribute2%type DEFAULT NULL,
						p_attribute3		IN		athoma12.notification_grp_params.attribute3%type DEFAULT NULL,
						p_attribute4		IN		athoma12.notification_grp_params.attribute4%type DEFAULT NULL,
						p_attribute5		IN		athoma12.notification_grp_params.attribute5%type DEFAULT NULL,
						p_attribute6		IN		athoma12.notification_grp_params.attribute6%type DEFAULT NULL,
						p_attribute7		IN		athoma12.notification_grp_params.attribute7%type DEFAULT NULL,
						p_attribute8		IN		athoma12.notification_grp_params.attribute8%type DEFAULT NULL,
						p_attribute9		IN		athoma12.notification_grp_params.attribute9%type DEFAULT NULL,
						p_attribute10		IN		athoma12.notification_grp_params.attribute10%type DEFAULT NULL) IS
	
	BEGIN
		p_notif_grp_param_id := NOTIFICATIONS_GRP_SEQ.nextval;
		INSERT INTO ATHOMA12.NOTIFICATION_GRP_PARAMS(notif_grp_param_id, notification_id, attribute1, attribute2, attribute3, attribute4, attribute5, attribute6
		, attribute7, attribute8, attribute9, attribute10)
		VALUES (p_notif_grp_param_id, p_notification_id, p_attribute1, p_attribute2, p_attribute3, p_attribute4, p_attribute5, p_attribute6, p_attribute7, p_attribute8, p_attribute9, p_attribute10);
		updateNotifWGroupParams(
						p_notification_id => p_notification_id,
						p_grp_attribute1  => p_notif_grp_param_id
						);
	END createNotificationGrpParams;

	PROCEDURE createNotification(
						p_notification_id 	OUT 	athoma12.notification_patrons.notification_id%type,
						p_template_name 	IN 		athoma12.notification_patrons.template_name%type,
						p_patron_id 		IN 		athoma12.notification_patrons.patron_id%type,
						p_attribute1		IN		athoma12.notification_patrons.attribute1%type DEFAULT NULL,
						p_attribute2		IN		athoma12.notification_patrons.attribute2%type DEFAULT NULL,
						p_attribute3		IN		athoma12.notification_patrons.attribute3%type DEFAULT NULL,
						p_attribute4		IN		athoma12.notification_patrons.attribute4%type DEFAULT NULL,
						p_attribute5		IN		athoma12.notification_patrons.attribute5%type DEFAULT NULL,
						p_attribute6		IN		athoma12.notification_patrons.attribute6%type DEFAULT NULL,
						p_attribute7		IN		athoma12.notification_patrons.attribute7%type DEFAULT NULL,
						p_attribute8		IN		athoma12.notification_patrons.attribute8%type DEFAULT NULL,
						p_attribute9		IN		athoma12.notification_patrons.attribute9%type DEFAULT NULL,
						p_attribute10		IN		athoma12.notification_patrons.attribute10%type DEFAULT NULL,
						p_grp_attribute1 	IN		athoma12.notification_grp_params.notif_grp_param_id%type DEFAULT NULL,
						p_grp_attribute2 	IN 		athoma12.notification_grp_params.notif_grp_param_id%type DEFAULT NULL,						
						p_notif_sent		IN		athoma12.notification_patrons.notif_sent%type DEFAULT NULL,
						p_notif_seen 		IN 		athoma12.notification_patrons.notif_seen%type DEFAULT NULL) IS
		l_notif_grp_param_id athoma12.notification_grp_params.notif_grp_param_id%type;
	BEGIN
		p_notification_id := NOTIFICATIONS_SEQ.nextval;
		
		INSERT INTO ATHOMA12.NOTIFICATION_PATRONS(notification_id, template_name, patron_id, attribute1, attribute2, attribute3, attribute4, attribute5, attribute6
		, attribute7, attribute8, attribute9, attribute10, grp_attribute1, grp_attribute2, notif_sent, notif_seen)
		VALUES (p_notification_id, p_template_name, p_patron_id, p_attribute1, p_attribute2, p_attribute3, p_attribute4, p_attribute5, p_attribute6, p_attribute7, p_attribute8, p_attribute9, p_attribute10, l_notif_grp_param_id, null, nvl(p_notif_sent, 'N'), nvl(p_notif_seen, 'N'));

	END createNotification;

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