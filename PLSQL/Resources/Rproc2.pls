CREATE OR REPLACE PACKAGE RPROC2 AS
/* Version Control Comments Block

120.0 	PKATTEP 	Creation

*/

PROCEDURE resourceReqProc(
					r_patron_id		IN 			athoma12.patrons.patron_id%type,
					r_res_req		OUT 		pkattep.resource_req%type
					);

END RPROC2;
/