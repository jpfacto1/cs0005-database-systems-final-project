-- teacher_menu.sql

SET FEEDBACK OFF
SET VERIFY OFF
CL SCR

PROMPT =========================================================================================
PROMPT .                                     TEACHER MENU                                      .
PROMPT =========================================================================================
PROMPT [1] View Records
PROMPT [2] Add Records
PROMPT [3] Update Records
PROMPT [4] Delete Records
PROMPT [5] Logout and Go back to Main Menu
PROMPT =========================================================================================

PROMPT LOGGED IN AS: &input_id
PROMPT

ACCEPT v_choice NUMBER PROMPT '[Teacher Menu] | Enter Choice (1-5): '

SET TERMOUT OFF
COLUMN next_scr NEW_VALUE v_run
SELECT
    CASE
        WHEN &v_choice = 1 THEN 'teacher_view_records.sql'
        WHEN &v_choice = 2 THEN 'teacher_add_records.sql'
        WHEN &v_choice = 3 THEN 'teacher_update_records.sql'
        WHEN &v_choice = 4 THEN 'teacher_delete_records.sql'
        WHEN &v_choice = 5 THEN 'logout.sql'
        ELSE 'teacher_menu.sql'
    END AS next_scr
FROM dual;
SET TERMOUT ON

@&v_run