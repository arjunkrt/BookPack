CREATE OR REPLACE PACKAGE RPROC2 AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

PROCEDURE resourceReqProc(
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_res_req		OUT 		pkattep.resource_req%type
					)
r_rtype_id athoma12.patrons.patron_id%type;
rr_patron_id pkattep.resource_req%type;

r_what VARCHAR2(20);
r_name VARCHAR2(50);
r_position VARCHAR2(50);
r_lib_name VARCHAR2(50);

CURSOR r_waitlist is SELECT patron_id, rtype_id FROM pkattep.waitlist;
	
BEGIN

	OPEN r_waitlist;
   LOOP
      FETCH r_waitlist into rr_patron_id, r_rtype_id;
      EXIT WHEN r_waitlist%notfound;
      
   IF r_patron_id == rr_patron_id THEN
	  
   -- Get the type for r_rtype_id
   
   	  SELECT type INTO r_type FROM pkattep.RESOURCE_TYPES WHERE rtype_id = r_rtype_id;
		 
		IF r_type == 'PB' THEN
	    	SELECT title INTO r_name FROM pkattep.publications WHERE rtype_id = r_rtype_id;
			INSERT INTO r_res_req (what, name, position, lib_name)
				VALUES ('Book', r_name, NULL, NULL);
	  
		ELSIF r_type == 'PJ' THEN
	    	SELECT title INTO r_name FROM pkattep.publications WHERE rtype_id = r_rtype_id;
			INSERT INTO r_res_req (what, name, position, lib_name)
				VALUES ('Journal', r_name, NULL, NULL);  
	
		ELSIF r_type == 'PC' THEN
	    	SELECT title INTO r_name FROM pkattep.publications WHERE rtype_id = r_rtype_id;
			INSERT INTO r_res_req (what, name, position, lib_name)
				VALUES ('Conference Proceeding', r_name, NULL, NULL);

		ELSIF r_type == 'C' THEN
	    	SELECT model INTO r_name FROM pkattep.cameras WHERE rtype_id = r_rtype_id;
			INSERT INTO r_res_req (what, name, position, lib_name)
				VALUES ('Camera', r_name, NULL, NULL);

		ELSIF r_type == 'RS' THEN
	    		SELECT RO.room_id, RO.position, L.lib_name
				INTO r_name, r_position, r_lib_name
				FROM pkattep.Rooms RO, pkattep.Resources R, pkattep.library L
				WHERE RO.rtype_id = R.rtype_id AND R.lib_id = L.lib_id;
				
			INSERT INTO r_res_req (what, name, position, lib_name)
				VALUES ('Study Room', r_name, r_position, r_lib_name);
	
		ELSIF r_type == 'RC' THEN
	    		SELECT RO.room_id, RO.position, L.lib_name
				INTO r_name, r_position, r_lib_name
				FROM pkattep.Rooms RO, pkattep.Resources R, pkattep.library L
				WHERE RO.rtype_id = R.rtype_id AND R.lib_id = L.lib_id;
				
			INSERT INTO r_res_req (what, name, position, lib_name)
				VALUES ('Conference Room', r_name, r_position, r_lib_name);
				
		END IF;
	
	
	END IF;  
   END LOOP;
   CLOSE r_waitlist;
									
END resourceReqProc;		

END RPROC2;
/