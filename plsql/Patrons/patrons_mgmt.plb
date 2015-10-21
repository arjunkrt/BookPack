CREATE OR REPLACE PACKAGE BODY PATRONS_MGMT AS
/* Version Control Comments Block

120.0 	ATHOMA12 	Creation

*/

	PROCEDURE addPatron(p_patron_id 	OUT		athoma12.patrons.patron_id%type,
						p_fName			IN 		athoma12.patrons.first_name%type, 
						p_lName			IN 		athoma12.patrons.last_name%type,
						p_dob			IN		athoma12.patrons.date_of_birth%type,
						p_sex			IN 		athoma12.patrons.sex%type,
						p_nationality	IN 		athoma12.patrons.nationality%type,
						p_department	IN 		athoma12.patrons.department%type,
						p_username		IN 		athoma12.patrons.username%type,
						p_password		IN 		athoma12.patrons.password_hash%type,
						p_patron_type   IN 		athoma12.patrons.patron_type%type) IS
	BEGIN
		p_patron_id := patrons_seq.nextval;
		INSERT INTO ATHOMA12.PATRONS(patron_id, first_name, last_name, date_of_birth, sex, nationality, department, username, password_hash, patron_type)
		VALUES (p_patron_id, p_fName,p_lName,p_dob,p_sex,p_nationality,p_department,p_username,p_password, p_patron_type);
		
	END addPatron;

	PROCEDURE addStudentProgram(
						p_program_id	OUT 	athoma12.student_programs.program_id%type,
						p_degree_program	IN  athoma12.student_programs.degree_program%type,
						p_st_classification 	IN  athoma12.student_programs.st_classification%type,
						p_st_category 	IN 		athoma12.student_programs.st_category%type
						) IS
	BEGIN
		p_program_id := student_programs_seq.nextval;
		INSERT INTO ATHOMA12.STUDENT_PROGRAMS(program_id, degree_program, st_classification, st_category)
		VALUES (p_program_id, p_degree_program, p_st_classification, p_st_category);
			
	END addStudentProgram;

	PROCEDURE addPhone(
						p_phone_id 		OUT 	athoma12.phones.phone_id%type,
						p_phone_number	IN		athoma12.phones.phone_number%type
						) IS
	BEGIN
		p_phone_id := phones_seq.nextval;
		INSERT INTO ATHOMA12.phones(phone_id, phone_number)
		VALUES (p_phone_id, p_phone_number);
		
	END addPhone;
					
	PROCEDURE addAddress(
						p_address_id 	OUT 	athoma12.addresses.address_id%type,
						p_address_line_1 IN		athoma12.addresses.address_line_1%type,
						p_address_line_2 IN 	athoma12.addresses.address_line_2%type,
						p_address_line_3 IN 	athoma12.addresses.address_line_3%type,
						p_city 			IN 		athoma12.addresses.city%type,
						p_state 		IN 		athoma12.addresses.state%type,
						p_country		IN 		athoma12.addresses.country%type
						) IS
	BEGIN
		p_address_id := addresses_seq.nextval;
		INSERT INTO ATHOMA12.addresses(address_id, address_line_1, address_line_2, address_line_3, city, state, country)
		VALUES (p_address_id, p_address_line_1, p_address_line_2, p_address_line_3, p_city, p_state, p_country);
	END addAddress;	

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
						p_country		IN 		athoma12.addresses.country%type DEFAULT NULL	
						) IS

		l_dup_count NUMBER := 0;
		duplicateuser EXCEPTION;
		l_patron_id NUMBER := 0;
		l_student_program_id NUMBER := 0;
		l_phone_id NUMBER := 0;
		l_alt_phone_id NUMBER := 0;
		l_address_id NUMBER :=0;
		l_program_id NUMBER := 0;
	BEGIN
		SELECT COUNT(*) INTO l_dup_count FROM athoma12.patrons WHERE
		username = p_username;
		if (l_dup_count <> 0) THEN
			RAISE duplicateuser;
		end if;
		--No duplicate patron found.. proceed.
		addPatron(
						p_patron_id	=> l_patron_id, 
						p_fName	=> p_fName,
						p_lName	=> p_lName,
						p_dob	=> p_dob,
						p_sex	=> p_sex,
						p_nationality	=> p_nationality,
						p_department	=> p_department,
						p_username	=> p_username,
						p_password	=> p_password,
						p_patron_type => 'S'

		);
		--Created Patron

		addPhone(
						p_phone_id	=> l_phone_id, 
						p_phone_number	=> p_phone_number

		);	

		addPhone(
						p_phone_id	=> l_alt_phone_id, 
						p_phone_number	=> p_alt_phone_number

		);				
		BEGIN
			SELECT program_id INTO l_program_id FROM athoma12.student_programs
			WHERE degree_program = p_degree_program
			AND   st_classification = p_st_classification
			AND   st_category = p_st_category;
		EXCEPTION
			WHEN OTHERS THEN
				--Exception occurred.. either too many rows, or no rows. Proceed without updating l_program_id
				l_program_id := 0;
		END;
		p_student_id := STUDENTS_SEQ.nextval;
		INSERT INTO athoma12.students(student_id, patron_id, program_id, phone_id, alt_phone_id, address_id)
		VALUES (p_student_id, l_patron_id, l_program_id, l_phone_id, l_alt_phone_id, l_address_id);

	EXCEPTION
		WHEN duplicateuser THEN
			p_student_id := -1;

	END addStudent;



END PATRONS_MGMT;
/