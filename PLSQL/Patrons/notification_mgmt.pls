CREATE OR REPLACE PACKAGE NOTIFICATION_MGMT AUTHID DEFINER AS
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
						p_name0				IN		athoma12.notification_grp_params.attribute_name%type DEFAULT NULL,
						p_name1				IN		athoma12.notification_grp_params.attribute_name%type DEFAULT NULL,
						p_name2				IN		athoma12.notification_grp_params.attribute_name%type DEFAULT NULL,
						p_name3				IN		athoma12.notification_grp_params.attribute_name%type DEFAULT NULL,
						p_name4				IN		athoma12.notification_grp_params.attribute_name%type DEFAULT NULL,
						p_name5				IN		athoma12.notification_grp_params.attribute_name%type DEFAULT NULL,
						p_name6				IN		athoma12.notification_grp_params.attribute_name%type DEFAULT NULL,
						p_name7				IN		athoma12.notification_grp_params.attribute_name%type DEFAULT NULL,
						p_name8				IN		athoma12.notification_grp_params.attribute_name%type DEFAULT NULL,
						p_name9				IN		athoma12.notification_grp_params.attribute_name%type DEFAULT NULL,						
						p_ind_attr_count	IN 		NUMBER
);
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
						p_name0				IN		athoma12.notification_attributes.attribute_name%type DEFAULT NULL,
						p_name1				IN		athoma12.notification_attributes.attribute_name%type DEFAULT NULL,
						p_name2				IN		athoma12.notification_attributes.attribute_name%type DEFAULT NULL,
						p_name3				IN		athoma12.notification_attributes.attribute_name%type DEFAULT NULL,
						p_name4				IN		athoma12.notification_attributes.attribute_name%type DEFAULT NULL,
						p_name5				IN		athoma12.notification_attributes.attribute_name%type DEFAULT NULL,
						p_name6				IN		athoma12.notification_attributes.attribute_name%type DEFAULT NULL,
						p_name7				IN		athoma12.notification_attributes.attribute_name%type DEFAULT NULL,
						p_name8				IN		athoma12.notification_attributes.attribute_name%type DEFAULT NULL,
						p_name9				IN		athoma12.notification_attributes.attribute_name%type DEFAULT NULL,						
						p_notif_sent		IN		athoma12.notification_patrons.notif_sent%type DEFAULT NULL,
						p_notif_seen 		IN 		athoma12.notification_patrons.notif_seen%type DEFAULT NULL,
						p_attr_count 		IN 		NUMBER);
/*
PROCEDURE updateNotifWGroupParams(
						p_notification_id 	IN	 	athoma12.notification_patrons.notification_id%type,
						p_grp_attribute1 	IN OUT	athoma12.notification_grp_params.notif_grp_param_id%type,
						p_grp_attribute2 	IN		athoma12.notification_grp_params.notif_grp_param_id%type DEFAULT NULL
);
*/
PROCEDURE updateNotificationSeen(
						p_notification_id 	OUT 	athoma12.notification_patrons.notification_id%type,
						p_notif_seen 		IN 		athoma12.notification_patrons.notif_seen%type
);
PROCEDURE updateNotificationSent(
						p_notification_id 	OUT 	athoma12.notification_patrons.notification_id%type,
						p_notif_sent 		IN 		athoma12.notification_patrons.notif_sent%type
);

PROCEDURE runFirstReminder;
PROCEDURE runSecondReminder;
PROCEDURE waitListNotification(
						p_borrow_id 		IN 		athoma12.borrows.borrow_id%type						
);
PROCEDURE runFirstFeeReminder;
PROCEDURE runSecondFeeReminder;
PROCEDURE runLastFeeReminder;
PROCEDURE suspendAccount;
PROCEDURE cameraReservationCancelled(
							p_rtype_id 		IN 		athoma12.resource_types.rtype_id%type,						
							p_reservation_start IN 	athoma12.waitlist.reservation_start%type
	);
PROCEDURE daemonCalls;

END NOTIFICATION_MGMT;
/