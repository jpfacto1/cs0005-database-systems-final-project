-- teacher_view_records_subjects.sql

SET SERVEROUTPUT ON
SET FEEDBACK OFF
SET VERIFY OFF
CL SCR

PROMPT =========================================================================================
PROMPT .                                VIEW SUBJECT RECORDS                                   .
PROMPT =========================================================================================

DECLARE
    CURSOR c_subjects IS
        SELECT subject_code, subject_name, professor
        FROM subjects
        ORDER BY subject_code;
        
    v_found BOOLEAN := FALSE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        RPAD('CODE', 15) || 
        RPAD('SUBJECT NAME', 40) || 
        'ASSIGNED PROFESSOR'
    );
    DBMS_OUTPUT.PUT_LINE('=========================================================================================');

    FOR r IN c_subjects LOOP
        v_found := TRUE;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(r.subject_code, 15) || 
            RPAD(UPPER(r.subject_name), 40) || 
            NVL(UPPER(r.professor), 'TBA')
        );
    END LOOP;

    IF NOT v_found THEN
        DBMS_OUTPUT.PUT_LINE('[Error] No subject records found.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('=========================================================================================');
END;
/

PAUSE Go back to previous menu?

@teacher_view_records.sql