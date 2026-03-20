-- teacher_view_records.sql

SET FEEDBACK OFF
SET VERIFY OFF
SET SERVEROUTPUT ON
CL SCR

PROMPT =========================================================================================
PROMPT .                                    VIEW RECORDS                                       .
PROMPT =========================================================================================
PROMPT [1] View Students
PROMPT [2] View Professors
PROMPT [3] View Subjects
PROMPT [4] Go back to Teacher Menu
PROMPT =========================================================================================

ACCEPT v_view_choice NUMBER PROMPT '[View Records] | Enter Choice (1-4): '

SET TERMOUT OFF
COLUMN next_scr NEW_VALUE v_next

SELECT
    CASE
        WHEN &v_view_choice = 1 THEN 'teacher_view_records_students.sql'
        WHEN &v_view_choice = 2 THEN 'teacher_view_records_teachers.sql'
        WHEN &v_view_choice = 3 THEN 'teacher_view_records_subjects.sql'
        WHEN &v_view_choice = 4 THEN 'teacher_menu.sql'
        ELSE 'teacher_view_records.sql'
    END AS next_scr
FROM dual;

SET TERMOUT ON

@&v_next