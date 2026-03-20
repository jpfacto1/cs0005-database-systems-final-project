-- delete_subject.sql

SET VERIFY OFF
SET SERVEROUTPUT ON
SET FEEDBACK OFF
CL SCR

PROMPT =========================================================================================
PROMPT .                                 DELETE SUBJECT RECORDS                                .
PROMPT =========================================================================================

COLUMN subject_code FORMAT A15 HEADING 'CODE'
COLUMN subject_name FORMAT A30 HEADING 'TITLE'
COLUMN professor    FORMAT A25 HEADING 'PROFESSOR'

PROMPT CURRENT SUBJECT LIST:
PROMPT =========================================================================================
SELECT subject_code, subject_name, professor FROM subjects ORDER BY subject_code;
PROMPT =========================================================================================

ACCEPT v_sub PROMPT '[Delete Records] Enter Subject Code to Delete: '

DECLARE
    v_name_found VARCHAR2(100);
    v_count      NUMBER;
    v_code       VARCHAR2(20) := UPPER('&v_sub');
BEGIN
    SELECT COUNT(*) INTO v_count FROM subjects WHERE subject_code = v_code;
    
    IF v_count > 0 THEN
        SELECT subject_name INTO v_name_found FROM subjects WHERE subject_code = v_code;
        
        DELETE FROM grades WHERE subject_code = v_code;
        DELETE FROM subjects WHERE subject_code = v_code;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Subject ' || v_code || ' - ' || v_name_found || ' removed.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[Error] Subject Code ' || v_code || ' not found.');
    END IF;
END;
/

PROMPT =========================================================================================
PROMPT UPDATED SUBJECT LIST:
PROMPT =========================================================================================

SELECT subject_code, subject_name, professor FROM subjects ORDER BY subject_code;

PROMPT =========================================================================================
PROMPT
PAUSE Go back to Delete Records Menu?

CLEAR COLUMNS
UNDEFINE v_sub

@teacher_delete_records.sql