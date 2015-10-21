CREATE OR REPLACE PACKAGE PATRONS_MGMT AUTHID CURRENT_USER AS
/* Version Control Comments Block

120.0 	ATHOMA12 	Creation

*/

PROCEDURE addPatron(
					p_patron_id		OUT 	athoma12.patrons.patron_id%type,
					p_fName 		IN		athoma12.patrons.first_name%type, 
					p_lName 		IN 		athoma12.patrons.last_name%type,
					p_dob 			IN 		athoma12.patrons.date_of_birth%type,
					p_sex 			IN 		athoma12.patrons.sex%type,
					p_nationality 	IN 		athoma12.patrons.nationality%type,
					p_department 	IN 		athoma12.patrons.department%type,
					p_username  	IN 		athoma12.patrons.username%type,
					p_password 		IN 		athoma12.patrons.password_hash%type);

PROCEDURE addStudentProgram(
					p_program_id	OUT 	athoma12.student_programs.program_id%type,
					p_degree_program	IN  athoma12.student_programs.degree_program%type,
					p_st_classification 	IN  athoma12.student_programs.st_classification%type,
					p_st_category 	IN 		athoma12.student_programs.st_category%type
					);

PROCEDURE addPhone(
					p_phone_id 		OUT 	athoma12.phones.phone_id%type,
					p_phone_number	IN		athoma12.phones.phone_number%type
					);

PROCEDURE addAddress(
					p_address_id 	OUT 	athoma12.addresses.address_id%type,
					p_address_line_1 IN		athoma12.addresses.address_line_1%type,
					p_address_line_2 IN 	athoma12.addresses.address_line_2%type,
					p_address_line_3 IN 	athoma12.addresses.address_line_3%type,
					p_city 			IN 		athoma12.addresses.city%type,
					p_state 		IN 		athoma12.addresses.state%type,
					p_country		IN 		athoma12.addresses.country%type
					);

PROCEDURE addStudent(
					p_student_id	OUT 	athoma12.students.student_id%type,
					p_fName 		IN		athoma12.patrons.first_name%type, 
					p_lName 		IN 		athoma12.patrons.last_name%type,
					p_dob 			IN 		athoma12.patrons.date_of_birth%type,
					p_sex 			IN 		athoma12.patrons.sex%type,
					p_nationality 	IN 		athoma12.patrons.nationality%type,
					p_department 	IN 		athoma12.patrons.department%type,
					p_username  	IN 		athoma12.patrons.username%type,
					p_password 		IN 		athoma12.patrons.password_hash%type,
					p_degree_program IN 	athoma12.student_programs.degree_program%type DEFAULT NULL,
					p_st_classification IN 	athoma12.student_programs.st_classification%type DEFAULT NULL,
					p_st_category	IN 		athoma12.student_programs.st_category%type DEFAULT NULL,
					p_phone_number	IN 		athoma12.phones.phone_number%type DEFAULT NULL,
					p_alt_phone_number IN 	athoma12.phones.phone_number%type DEFAULT NULL,
					p_address_line_1 	IN	athoma12.addresses.address_line_1%type DEFAULT NULL,
					p_address_line_2 	IN 	athoma12.addresses.address_line_2%type DEFAULT NULL,
					p_address_line_3	IN 	athoma12.addresses.address_line_3%type DEFAULT NULL,
					p_city		 	IN 		athoma12.addresses.city%type DEFAULT NULL,
					p_state			IN		athoma12.addresses.state%type DEFAULT NULL,
					p_country		IN 		athoma12.addresses.country%type	DEFAULT NULL	
					);





END PATRONS_MGMT;
/