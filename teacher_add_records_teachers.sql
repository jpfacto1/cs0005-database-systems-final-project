-- teacher_add_records_professors.sql

SET FEEDBACK OFF
SET VERIFY OFF
SET SERVEROUTPUT ON
CL SCR

PROMPT =========================================================================================
PROMPT .                                  ADD PROFESSOR RECORD                                 .
PROMPT =========================================================================================

ACCEPT v_full_name PROMPT '[Add Professor Records] | Enter Professor Full Name: '

PROMPT =========================================================================================
PROMPT AVAILABLE SUBJECTS TO TEACH:
COLUMN subject_code FORMAT A12 HEADING 'CODE'
COLUMN subject_name FORMAT A30 HEADING 'SUBJECT TITLE'
SELECT subject_code, subject_name FROM subjects;
PROMPT =========================================================================================
ACCEPT v_scode PROMPT '[Add Professor Records] | Enter Subject Code to assign: '

DECLARE
    v_input_name VARCHAR2(100) := '&v_full_name';
    v_first_init VARCHAR2(2);
    v_last_name  VARCHAR2(50);
    v_generated_user VARCHAR2(20);
    v_generated_pass VARCHAR2(30);
    v_check_subj NUMBER;
BEGIN
    add_professor('&v_full_name', '&v_scode');
END;
/

PAUSE Go back to Add Records Menu?

@teacher_add_records.sql