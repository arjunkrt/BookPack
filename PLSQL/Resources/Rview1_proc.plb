--Following procedures will give first layer display of each of resources

PROCEDURE viewRooms( patron_type IN boolean ) IS
	BEGIN
    
    IF (patron_type == 0) THEN
        SELECT * FROM ROOM_VIEW_STUDENTS;
    ELSE
        SELECT * FROM ROOM_VIEW_FACULTY;
    END IF; 
     
END viewRooms;

PROCEDURE viewPublications IS
	BEGIN
    
    DBMS_OUTPUT.PUTLINE('Books --'||CHR(13)||CHR(10));
    SELECT * FROM BOOK_VIEW;
    
    DBMS_OUTPUT.PUTLINE('Journals --'||CHR(13)||CHR(10));
    SELECT * FROM JOURNALS_VIEW;
    
    DBMS_OUTPUT.PUTLINE('Conference Proceedings --'||CHR(13)||CHR(10));
    SELECT * FROM CONF_VIEW;
     
END viewPublications;

PROCEDURE viewCameras IS
BEGIN

    SELECT * FROM CAM_VIEW;

END viewCameras;


--Following procedures will give second layer display of each of resources after the user has selected to view one of them

PROCEDURE viewSpecRoom(room_ka_id IN pkattep.ROOMS.room_id%TYPE) IS
    BEGIN
    
END viewSpecRoom;


PROCEDURE viewSpecPub(P_ka_id IN pkattep.PUBLICATIONS.Pid%TYPE,
                    P_ka_type IN NUMBER) IS
    p_identifier NUMBER
    p_title VARCHAR2
    p_year NUMBER
    p_type VARCHAR2
    
    BEGIN
    
    SELECT title INTO p_title FROM PUBLICATIONS WHERE pkattep.PUBLICATIONS.title = p_ka_id;
    
    IF p_ka_type = 0 THEN
    
        DBMS_OUTPUT.PUTLINE('The book you selected is --');
        DBMS_OUTPUT.PUTLINE('
    