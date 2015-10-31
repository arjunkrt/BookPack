CREATE OR REPLACE PACKAGE RESOURCES_MGMT AUTHID CURRENT_USER AS
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
					p_h_or_e 		IN 		VARCHAR2
					);
PROCEDURE createAuthor(
					p_aid 			IN OUT 	athoma12.authors.aid%type,
					p_author_name	IN 		athoma12.authors.author_name%type
					);

PROCEDURE mapPubAuthor(
					p_rtype_id 		IN 		athoma12.publications_authors.rtype_id%type,
					p_aid			IN 		athoma12.publications_authors.aid%type
					);
PROCEDURE addJournal(
					p_rtype_id 		IN OUT	athoma12.journals.rtype_id%type,
					p_issn 			IN 		athoma12.journals.issn%type,
					p_year 		 	IN 		athoma12.publications.year%type,
					p_title			IN 		athoma12.publications.title%type,
					p_quantity 		IN 		INTEGER,
					p_lib_id 		IN 		athoma12.library.lib_id%type,
					p_h_or_e 		IN 		VARCHAR2);	
PROCEDURE addConf(
					p_rtype_id 		IN OUT	athoma12.conf_proceedings.rtype_id%type,
					p_conf_no		IN 		athoma12.conf_proceedings.conf_no%type,
					p_conf_name		IN 		athoma12.conf_proceedings.conf_name%type,
					p_year 		 	IN 		athoma12.publications.year%type,
					p_title			IN 		athoma12.publications.title%type,
					p_quantity 		IN 		INTEGER,
					p_lib_id 		IN 		athoma12.library.lib_id%type,
					p_h_or_e 		IN 		VARCHAR2);		
					
PROCEDURE addRoom(
					p_rtype_id 		IN OUT	athoma12.rooms.rtype_id%type,
					p_room_id		IN 		athoma12.rooms.room_id%type,
					p_position 		IN 		athoma12.rooms.position%type,
					p_capacity 		IN 		athoma12.rooms.capacity%type,
					p_roomtype		IN 		athoma12.rooms.roomtype%type,
					p_quantity 		IN 		INTEGER,
					p_lib_id 		IN 		athoma12.library.lib_id%type) ;
PROCEDURE addCamera(
					p_rtype_id 		IN OUT	athoma12.cameras.rtype_id%type,
					p_cam_id		IN 		athoma12.cameras.cam_id%type,
					p_model 		IN 		athoma12.cameras.model%type,
					p_memory 		IN 		athoma12.cameras.memory%type,
					p_lens_config	IN 		athoma12.cameras.lens_config%type,
					p_make			IN 		athoma12.cameras.make%type,
					p_quantity 		IN 		INTEGER,
					p_lib_id 		IN 		athoma12.library.lib_id%type) ;	

PROCEDURE getResourceDetailsCursor(
					p_borrow_id		IN 		athoma12.borrows.borrow_id%type,
					p_resource_type OUT	 	athoma12.resource_types.type%type,
					p_resources_cursor OUT 	SYS_REFCURSOR
					);											

END RESOURCES_MGMT;
/