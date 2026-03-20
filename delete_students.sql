-- delete_student.sql

SET VERIFY OFF
SET FEEDBACK OFF
SET SERVEROUTPUT ON
CL SCR

PROMPT =========================================================================================
PROMPT .                               DELETE STUDENT RECORDS                                  .
PROMPT =========================================================================================

COLUMN student_id FORMAT A15 HEADING 'ID NUMBER'
COLUMN name       FORMAT A30 HEADING 'STUDENT NAME'
SELECT student_id, name FROM students ORDER BY name;

ACCEPT v_id PROMPT '[Delete Records] | Enter Student ID to Delete: '

COLUMN temp_name NEW_VALUE v_student_name
SET TERMOUT OFF
SELECT NVL(MAX(name), 'Not Found') AS temp_name FROM students WHERE student_id = '&v_id';
SET TERMOUT ON

DECLARE
    v_check NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_check FROM students WHERE student_id = '&v_id';
    IF v_check > 0 THEN
        DELETE FROM grades WHERE student_id = '&v_id';
        DELETE FROM students WHERE student_id = '&v_id';
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('&v_id successfully deleted from the table.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No record found for ID &v_id.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[Error]' || SQLERRM);
END;
/

PAUSE Go back to Delete Records Menu?

UNDEFINE v_id
UNDEFINE v_student_name
@teacher_delete_records.sql