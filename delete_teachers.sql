-- delete_professor.sql

SET VERIFY OFF
SET SERVEROUTPUT ON
SET FEEDBACK OFF
CL SCR

PROMPT =========================================================================================
PROMPT .                                 DELETE PROFESSOR RECORDS                              .
PROMPT =========================================================================================

COLUMN username FORMAT A20 HEADING 'USERNAME'
COLUMN name     FORMAT A30 HEADING 'PROFESSOR NAME'

PROMPT CURRENT PROFESSOR LIST:
PROMPT =========================================================================================
SELECT username, name FROM teachers ORDER BY name;
PROMPT =========================================================================================

ACCEPT v_user PROMPT '[Delete Records] | Enter Professor Username to Delete: '

DECLARE
    v_name_found VARCHAR2(100);
    v_count      NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM teachers WHERE username = '&v_user';
    
    IF v_count > 0 THEN
        SELECT name INTO v_name_found FROM teachers WHERE username = '&v_user';
        UPDATE subjects SET professor = 'TBA' WHERE professor = v_name_found;
        DELETE FROM teachers WHERE username = '&v_user';
        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE('Professor ' || v_name_found || ' removed.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[Error] Professor Username "&v_user" not found.');
    END IF;
END;
/

PROMPT =========================================================================================
PROMPT UPDATED PROFESSOR LIST:
PROMPT =========================================================================================
SELECT username, name FROM teachers ORDER BY name;
PROMPT =========================================================================================

PROMPT
PAUSE Go back to Delete Records Menu?

CLEAR COLUMNS
UNDEFINE v_user

@teacher_delete_records.sql