-- teacher_login.sql
teacher_l
SET FEEDBACK OFF
SET VERIFY OFF
SET DEFINE ON
CL SCR

UNDEFINE input_id
UNDEFINE input_pass
UNDEFINE v_next

PROMPT =========================================================================================
PROMPT .                                     TEACHER LOGIN                                     .
PROMPT =========================================================================================

ACCEPT input_id PROMPT '[Teacher Login] | Enter Username: '
ACCEPT input_pass PROMPT '[Teacher Login] | Enter Password: ' HIDE

VARIABLE v_auth_count NUMBER
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM teachers
    WHERE username = '&input_id' AND password = '&input_pass';
   
    :v_auth_count := v_count;
END;
/

SET TERMOUT OFF
COLUMN next_scr NEW_VALUE v_next

SELECT
    CASE
        WHEN :v_auth_count = 1 THEN 'teacher_menu.sql'
        ELSE 'login_error.sql'
    END AS next_scr
FROM dual;
SET TERMOUT ON

@&v_next