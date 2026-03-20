-- student_login.sql

SET FEEDBACK OFF
SET VERIFY OFF
SET DEFINE ON
CL SCR

UNDEFINE input_id
UNDEFINE input_pass
UNDEFINE v_next

PROMPT =========================================================================================
PROMPT .                                     STUDENT LOGIN                                     .
PROMPT =========================================================================================

ACCEPT input_id PROMPT '[Student Login] | Enter Student Number: '
ACCEPT input_pass PROMPT '[Student Login] | Enter Password: ' HIDE

VARIABLE v_auth_count NUMBER
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM students
    WHERE student_id = '&input_id' AND password = '&input_pass';
   
    :v_auth_count := v_count;
END;
/

SET TERMOUT OFF
COLUMN input_id NEW_VALUE g_id
SELECT '&input_id' AS input_id FROM dual;
DEFINE g_id = '&input_id'
SET TERMOUT ON

COLUMN next_scr NEW_VALUE v_next
SELECT
    CASE
        WHEN :v_auth_count = 1 THEN 'student_menu.sql'
        ELSE 'login_error.sql'
    END AS next_scr
FROM dual;
SET TERMOUT ON

@&v_next