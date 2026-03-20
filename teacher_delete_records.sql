-- teacher_delete_records.sql

SET FEEDBACK OFF
SET VERIFY OFF
CL SCR

PROMPT =========================================================================================
PROMPT .                                     DELETE RECORDS                                    .
PROMPT =========================================================================================
PROMPT [1] Delete Student Record
PROMPT [2] Delete Professor Record
PROMPT [3] Delete Subject Record
PROMPT [4] Go back to Teacher Menu
PROMPT =========================================================================================
ACCEPT v_del_choice NUMBER PROMPT '[Delete Records] | Enter Choice (1-4): '

COLUMN next_scr NEW_VALUE v_next
SELECT
    CASE '&v_del_choice'
        WHEN '1' THEN 'delete_students.sql'
        WHEN '2' THEN 'delete_teachers.sql'
        WHEN '3' THEN 'delete_subjects.sql'
        WHEN '4' THEN 'teacher_menu.sql'
        ELSE 'teacher_delete_records.sql'
    END AS next_scr
FROM dual;

@&v_next