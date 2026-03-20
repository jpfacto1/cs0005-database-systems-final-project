-- main.sql

SET SERVEROUTPUT ON
SET FEEDBACK OFF
SET VERIFY OFF
SET ECHO OFF
SET HEADING OFF
SET PAGESIZE 0
SET DEFINE ON
SET TERMOUT ON
CL SCR

PROMPT =========================================================================================
PROMPT .                             JVS STUDENT MANAGEMENT SYSTEM                             .  
PROMPT =========================================================================================
PROMPT [1] Login as Teacher
PROMPT [2] Login as Student
PROMPT [3] View Developer Information
PROMPT [4] Exit
PROMPT =========================================================================================
PROMPT

ACCEPT v_choice NUMBER PROMPT '[Main Menu] | Enter Choice (1-4): '

SET TERMOUT OFF
COLUMN v_run NEW_VALUE v_run

SELECT CASE
    WHEN &v_choice = 1 THEN 'teacher_login.sql'
    WHEN &v_choice = 2 THEN 'student_login.sql'
    WHEN &v_choice = 3 THEN 'view_dev_info.sql'
    WHEN &v_choice = 4 THEN 'exit.sql'
    ELSE 'main.sql'                
END AS v_run
FROM dual;

SET TERMOUT ON
@&v_run