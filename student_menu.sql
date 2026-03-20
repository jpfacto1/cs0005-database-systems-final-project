-- student_menu.sql

CL SCR

PROMPT =========================================================================================
PROMPT .                                     STUDENT MENU                                      .
PROMPT =========================================================================================
PROMPT [1] View My Grades
PROMPT [2] Logout and Go Back to Main Menu
PROMPT =========================================================================================
PROMPT STUDENT NUMBER: &g_id
PROMPT

ACCEPT v_choice NUMBER PROMPT '[Student Menu] | Enter Choice (1-2): '

SET TERMOUT OFF
COLUMN init_pos NEW_VALUE v_pos
SELECT '1' AS init_pos FROM dual;

COLUMN next_scr NEW_VALUE v_next
SELECT
    CASE
        WHEN &v_choice = 1 THEN 'student_view_grades.sql'
        WHEN &v_choice = 2 THEN 'logout.sql'
        ELSE 'student_menu.sql'
    END AS next_scr
FROM dual;
SET TERMOUT ON

@&v_next