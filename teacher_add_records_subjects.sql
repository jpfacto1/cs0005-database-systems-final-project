-- teacher_add_records_subjects.sql

SET FEEDBACK OFF
SET VERIFY OFF
SET SERVEROUTPUT ON
CL SCR

PROMPT =========================================================================================
PROMPT .                                   ADD SUBJECT RECORD                                  .
PROMPT =========================================================================================

ACCEPT v_scode PROMPT '[Add Subject Record] | Enter Subject Code: '
ACCEPT v_sname PROMPT '[Add Subject Record] | Enter Subject Name: '

DECLARE
    v_check NUMBER;
BEGIN
    add_subject('&v_scode', '&v_sname');
END;
/

PAUSE Go back to previous menu?

@teacher_add_records.sql