CREATE OR REPLACE PACKAGE BODY RESOURCES_MGMT AS
/* Version Control Comments Block

120.0 	ATHOMA12 	Creation

*/
PROCEDURE addBook(
					p_rtype_id 		IN OUT	athoma12.books.rtype_id%type,
					p_isbn 			IN 		athoma12.books.isbn%type,
					p_edition 		IN 		athoma12.books.edition%type,
					p_reserved 		IN 		athoma12.books.reserved%type DEFAULT NULL,
					p_publishers 	IN 		athoma12.books.publishers%type,
					p_year 		 	IN 		athoma12.publications.year%type,
					p_title			IN 		athoma12.publications.title%type,
					p_quantity 		IN 		INTEGER,
					p_lib_id 		IN 		athoma12.library.lib_id%type,
					p_h_or_e 		IN 		VARCHAR2) IS
iter INTEGER(10) := 0;
BEGIN
	p_rtype_id := RTYPE_ID_SEQ.nextval;
	INSERT INTO athoma12.resource_types(rtype_id, type)
	VALUES(p_rtype_id, 'PB');
	INSERT INTO athoma12.publications(rtype_id, year, title)
	VALUES(p_rtype_id, p_year, p_title);
	INSERT INTO athoma12.books(rtype_id, isbn, edition, reserved, publishers)
	VALUES(p_rtype_id, p_isbn, p_edition, p_reserved, p_publishers);

	WHILE (iter < p_quantity AND (p_h_or_e = 'B' OR p_h_or_e = 'H'))
	LOOP
		INSERT INTO athoma12.resources(rid, rtype_id, status, lib_id) VALUES (RID_SEQ.nextval, p_rtype_id, 'Available', p_lib_id);
		iter := iter+1;
	END LOOP;

	IF (p_h_or_e = 'B' or p_h_or_e = 'E') THEN
		INSERT INTO athoma12.epublications(rtype_id, lib_id) VALUES(p_rtype_id, p_lib_id);
	END IF;

END addBook;
	
PROCEDURE createAuthor(
					p_aid 			IN OUT 	athoma12.authors.aid%type,
					p_author_name	IN 		athoma12.authors.author_name%type
					) IS 
BEGIN
	BEGIN
		select aid into p_aid from athoma12.authors where author_name = p_author_name;
		RETURN;
	EXCEPTION
		when others then
		p_aid := AID_SEQ.nextval;
		
	END;
	insert into athoma12.authors(aid, author_name) values(p_aid, p_author_name);

END createAuthor;

PROCEDURE mapPubAuthor(
					p_rtype_id 		IN 		athoma12.publications_authors.rtype_id%type,
					p_aid			IN 		athoma12.publications_authors.aid%type
					) IS
BEGIN
insert into athoma12.publications_authors(rtype_id, aid) values(p_rtype_id, p_aid);

END mapPubAuthor;

PROCEDURE addJournal(
					p_rtype_id 		IN OUT	athoma12.journals.rtype_id%type,
					p_issn 			IN 		athoma12.journals.issn%type,
					p_year 		 	IN 		athoma12.publications.year%type,
					p_title			IN 		athoma12.publications.title%type,
					p_quantity 		IN 		INTEGER,
					p_lib_id 		IN 		athoma12.library.lib_id%type,
					p_h_or_e 		IN 		VARCHAR2) IS
iter INTEGER(10) := 0;
BEGIN
	p_rtype_id := RTYPE_ID_SEQ.nextval;
	INSERT INTO athoma12.resource_types(rtype_id, type)
	VALUES(p_rtype_id, 'PJ');
	INSERT INTO athoma12.publications(rtype_id, year, title)
	VALUES(p_rtype_id, p_year, p_title);
	INSERT INTO athoma12.journals(rtype_id, issn)
	VALUES(p_rtype_id, p_issn);

	WHILE (iter < p_quantity AND (p_h_or_e = 'B' OR p_h_or_e = 'H'))
	LOOP
		INSERT INTO athoma12.resources(rid, rtype_id, status, lib_id) VALUES (RID_SEQ.nextval, p_rtype_id, 'Available', p_lib_id);
		iter := iter+1;
	END LOOP;

	IF (p_h_or_e = 'B' or p_h_or_e = 'E') THEN
		INSERT INTO athoma12.epublications(rtype_id, lib_id) VALUES(p_rtype_id, p_lib_id);
	END IF;

END addJournal;	

PROCEDURE addConf(
					p_rtype_id 		IN OUT	athoma12.conf_proceedings.rtype_id%type,
					p_conf_no		IN 		athoma12.conf_proceedings.conf_no%type,
					p_conf_name		IN 		athoma12.conf_proceedings.conf_name%type,
					p_year 		 	IN 		athoma12.publications.year%type,
					p_title			IN 		athoma12.publications.title%type,
					p_quantity 		IN 		INTEGER,
					p_lib_id 		IN 		athoma12.library.lib_id%type,
					p_h_or_e 		IN 		VARCHAR2) IS
iter INTEGER(10) := 0;
BEGIN
	p_rtype_id := RTYPE_ID_SEQ.nextval;
	INSERT INTO athoma12.resource_types(rtype_id, type)
	VALUES(p_rtype_id, 'PC');
	INSERT INTO athoma12.publications(rtype_id, year, title)
	VALUES(p_rtype_id, p_year, p_title);
	INSERT INTO athoma12.conf_proceedings(rtype_id, conf_no, conf_name)
	VALUES(p_rtype_id, p_conf_no, p_conf_name);

	WHILE (iter < p_quantity AND (p_h_or_e = 'B' OR p_h_or_e = 'H'))
	LOOP
		INSERT INTO athoma12.resources(rid, rtype_id, status, lib_id) VALUES (RID_SEQ.nextval, p_rtype_id, 'Available', p_lib_id);
		iter := iter+1;
	END LOOP;

	IF (p_h_or_e = 'B' or p_h_or_e = 'E') THEN
		INSERT INTO athoma12.epublications(rtype_id, lib_id) VALUES(p_rtype_id, p_lib_id);
	END IF;

END addConf;		
PROCEDURE addRoom(
					p_rtype_id 		IN OUT	athoma12.rooms.rtype_id%type,
					p_room_id		IN 		athoma12.rooms.room_id%type,
					p_position 		IN 		athoma12.rooms.position%type,
					p_capacity 		IN 		athoma12.rooms.capacity%type,
					p_roomtype		IN 		athoma12.rooms.roomtype%type,
					p_quantity 		IN 		INTEGER,
					p_lib_id 		IN 		athoma12.library.lib_id%type) IS
iter INTEGER(10) := 0;
BEGIN

	p_rtype_id := RTYPE_ID_SEQ.nextval;
	if p_roomtype = 'Study Room' THEN
		INSERT INTO athoma12.resource_types(rtype_id, type)
		VALUES(p_rtype_id, 'RS');
	ELSE 
		INSERT INTO athoma12.resource_types(rtype_id, type)
		VALUES(p_rtype_id, 'RC');
	END IF;
	INSERT INTO athoma12.rooms(rtype_id, room_id, position, capacity, roomtype)
		VALUES(p_rtype_id, p_room_id, p_position, p_capacity, p_roomtype);

	

	WHILE (iter < p_quantity)
	LOOP
		INSERT INTO athoma12.resources(rid, rtype_id, status, lib_id) VALUES (RID_SEQ.nextval, p_rtype_id, 'Available', p_lib_id);
		iter := iter+1;
	END LOOP;


END addRoom;
PROCEDURE addCamera(
					p_rtype_id 		IN OUT	athoma12.cameras.rtype_id%type,
					p_cam_id		IN 		athoma12.cameras.cam_id%type,
					p_model 		IN 		athoma12.cameras.model%type,
					p_memory 		IN 		athoma12.cameras.memory%type,
					p_lens_config	IN 		athoma12.cameras.lens_config%type,
					p_make			IN 		athoma12.cameras.make%type,
					p_quantity 		IN 		INTEGER,
					p_lib_id 		IN 		athoma12.library.lib_id%type) IS
iter INTEGER(10) := 0;
BEGIN

	p_rtype_id := RTYPE_ID_SEQ.nextval;
	INSERT INTO athoma12.resource_types(rtype_id, type)
		VALUES(p_rtype_id, 'C');
	INSERT INTO athoma12.cameras(rtype_id, cam_id, model, memory, lens_config, make)
		VALUES(p_rtype_id, p_cam_id, p_model, p_memory, p_lens_config, p_make);

	

	WHILE (iter < p_quantity)
	LOOP
		INSERT INTO athoma12.resources(rid, rtype_id, status, lib_id) VALUES (RID_SEQ.nextval, p_rtype_id, 'Available', p_lib_id);
		iter := iter+1;
	END LOOP;


END addCamera;

PROCEDURE getResourceDetailsCursor(
					p_borrow_id		IN 		athoma12.borrows.borrow_id%type,
					p_resource_type OUT	 	athoma12.resource_types.type%type,
					p_resources_cursor OUT 	SYS_REFCURSOR
					) IS
	l_rid athoma12.resources.rid%type;
BEGIN
	SELECT type, rid INTO p_resource_type, l_rid
	FROM user_checkout_summary UCS
	WHERE UCS.borrow_id = p_borrow_id;

	IF p_resource_type = 'PB' THEN
		OPEN p_resources_cursor FOR 
		SELECT * FROM athoma12.book_rid_details WHERE rid = l_rid;
	ELSIF p_resource_type = 'PC' THEN
		OPEN p_resources_cursor FOR 
		SELECT * FROM athoma12.conf_proc_rid_details WHERE rid = l_rid;
	ELSIF p_resource_type = 'PJ' THEN
		OPEN p_resources_cursor FOR 
		SELECT * FROM athoma12.journal_rid_details WHERE rid = l_rid;
	ELSIF p_resource_type = 'C' THEN
		OPEN p_resources_cursor FOR 
		SELECT * FROM athoma12.cam_rid_details WHERE rid = l_rid;
	ELSIF p_resource_type = 'RC' THEN
		OPEN p_resources_cursor FOR 
		SELECT * FROM athoma12.rooms_rid_details WHERE rid = l_rid;
	ELSIF p_resource_type = 'RS' THEN
		OPEN p_resources_cursor FOR 
		SELECT * FROM athoma12.rooms_rid_details WHERE rid = l_rid;
	END IF;
END getResourceDetailsCursor;

FUNCTION findAuthors(
					p_rtype_id 		IN 	athoma12.resource_types.rtype_id%type
					) RETURN VARCHAR2 IS

	l_authors  VARCHAR2(200) := '';

BEGIN
	select LISTAGG(qrst.author_name, ', ') WITHIN GROUP (ORDER BY qrst.author_name) into l_authors
	from (
		select pa.rtype_id, a.* from publications_authors pa, authors a
		where pa.aid = a.aid) QRST
	where qrst.rtype_id = p_rtype_id
	group by qrst.rtype_id
	;
	return l_authors;

END findAuthors;
END RESOURCES_MGMT;
/