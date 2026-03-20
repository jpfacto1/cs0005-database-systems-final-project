SET VERIFY OFF
SET SERVEROUTPUT ON
SET FEEDBACK OFF
CLEAR SCREEN

PROMPT =========================================================================================
PROMPT .                                 VIEW STUDENT RECORDS                                  .
PROMPT =========================================================================================

ACCEPT v_section PROMPT '[View Student Records] | Enter Section (TN21-TN29): '

PROMPT
PROMPT [1] View All Students
PROMPT [2] View Passing Students 
PROMPT [3] View Failed Students 
PROMPT [4] Go back to View Records Menu
PROMPT =========================================================================================
ACCEPT v_filter PROMPT '[View Student Records] | Enter Choice (1-4): '

DECLARE
    CURSOR c_filtered_students IS
        SELECT 
            s.student_id, 
            s.name, 
            s.section,
            NVL(ROUND(AVG(fn_calculate_gwa(
                fn_calculate_midterm(g.sa, g.ta, g.sw, g.rec, g.me),
                fn_calculate_final(g.sa, g.ta, g.sw, g.rec, g.fp, g.me, g.fe)
            ))), 0) as overall_gwa
        FROM students s
        LEFT JOIN grades g ON s.student_id = g.student_id  
        WHERE UPPER(TRIM(s.section)) = UPPER(TRIM('&v_section'))
        GROUP BY s.student_id, s.name, s.section
        ORDER BY s.name ASC;

    v_found  BOOLEAN := FALSE;
    v_choice NUMBER := TO_NUMBER('&v_filter');
    v_status VARCHAR2(10);
BEGIN
    IF v_choice = 4 THEN
        GOTO end_script;
    END IF;

    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE(RPAD('ID', 15) || RPAD('NAME', 30) || RPAD('GWA', 10) || 'STATUS');
    DBMS_OUTPUT.PUT_LINE('=========================================================================================');

    FOR r IN c_filtered_students LOOP
        
        IF r.overall_gwa >= 70 THEN
            v_status := 'PASSED';
        ELSE
            v_status := 'FAILED';
        END IF;

        IF (v_choice = 1) OR 
           (v_choice = 2 AND v_status = 'PASSED') OR 
           (v_choice = 3 AND v_status = 'FAILED') THEN
            
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.student_id, 15) ||
                RPAD(UPPER(r.name), 30) ||
                RPAD(TO_CHAR(r.overall_gwa), 10) ||
                v_status
            );
            v_found := TRUE;
        END IF;
    END LOOP;

    IF NOT v_found THEN
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('No records found for this filter/section.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('=========================================================================================');
    
    <<end_script>>
    NULL;
END;
/

PAUSE Go back to previous menu?

SET TERMOUT OFF
COLUMN next_scr NEW_VALUE v_next
SELECT
    CASE
        WHEN '&v_filter' = '4' THEN 'teacher_view_records.sql'
        ELSE 'teacher_view_records_students.sql'
    END AS next_scr
FROM dual;
SET TERMOUT ON

@&v_next