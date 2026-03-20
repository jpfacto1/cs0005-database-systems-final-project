-- teacher_view_records_teacher.sql

SET SERVEROUTPUT ON
CL SCR

PROMPT =========================================================================================
PROMPT .                            VIEW PROFESSOR RECORDS                                     .
PROMPT =========================================================================================

DECLARE
    CURSOR c_teachers IS
        SELECT username, name
        FROM teachers
        ORDER BY name;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('USERNAME',20) || 'FULL NAME');
    DBMS_OUTPUT.PUT_LINE('=========================================================================================');

    FOR r IN c_teachers LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(r.username,20) ||
            UPPER(r.name)
        );
    END LOOP;
END;
/

PAUSE Go back to previous menu?

@teacher_view_records.sql