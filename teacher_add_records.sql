-- teacher_add_records.sql

SET FEEDBACK OFF
SET VERIFY OFF
CL SCR

PROMPT =========================================================================================
PROMPT .                                     ADD RECORDS                                       .
PROMPT =========================================================================================
PROMPT [1] Add New Student
PROMPT [2] Add New Professor
PROMPT [3] Add New Subject
PROMPT [4] Go back to Teacher Menu
PROMPT =========================================================================================

ACCEPT v_add_choice NUMBER PROMPT '[Add Records] | Enter Choice (1-4): '

SET TERMOUT OFF
COLUMN next_scr NEW_VALUE v_run
SELECT
    CASE
        WHEN &v_add_choice = 1 THEN 'teacher_add_records_students.sql'
        WHEN &v_add_choice = 2 THEN 'teacher_add_records_teachers.sql'
        WHEN &v_add_choice = 3 THEN 'teacher_add_records_subjects.sql'
        ELSE 'teacher_menu.sql'
    END AS next_scr
FROM dual;
SET TERMOUT ON

@&v_run