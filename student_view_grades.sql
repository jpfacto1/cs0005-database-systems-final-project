-- student_view_grades.sql

SET SERVEROUTPUT ON
SET FEEDBACK OFF
SET VERIFY OFF

COLUMN col_pos NEW_VALUE v_pos
SELECT NVL('&v_pos', '1') AS col_pos FROM dual;

CL SCR
PROMPT =========================================================================================
PROMPT .                                     VIEW GRADES                                       .
PROMPT =========================================================================================

DECLARE
    v_id        VARCHAR2(15) := '&g_id'; 
    v_current   NUMBER := TO_NUMBER('&v_pos');
    v_total     NUMBER;
    
    v_midterm   NUMBER;
    v_final     NUMBER;
    v_gwa       NUMBER;
    v_status    VARCHAR2(15);

    CURSOR c_item IS
        SELECT * FROM (
            SELECT s.name, s.section, sub.subject_code, sub.subject_name, sub.professor, 
                   g.sa, g.ta, g.sw, g.rec, g.fp, g.me, g.fe,
                   ROW_NUMBER() OVER (ORDER BY sub.subject_code) as rn
            FROM students s
            JOIN grades g ON s.student_id = g.student_id
            JOIN subjects sub ON g.subject_code = sub.subject_code
            WHERE s.student_id = v_id
        ) WHERE rn = v_current;

    r c_item%ROWTYPE;
BEGIN
    SELECT COUNT(*) INTO v_total FROM grades WHERE student_id = v_id;

    OPEN c_item;
    FETCH c_item INTO r;
    
    IF c_item%FOUND THEN
        v_midterm := fn_calculate_midterm(r.sa, r.ta, r.sw, r.rec, r.me);
        v_final   := fn_calculate_final(r.sa, r.ta, r.sw, r.rec, r.fp, r.me, r.fe);
        v_gwa     := fn_calculate_gwa(v_midterm, v_final);
        v_status  := fn_get_status(v_gwa);

        DBMS_OUTPUT.PUT_LINE('STUDENT NO : ' || v_id);
        DBMS_OUTPUT.PUT_LINE('NAME       : ' || UPPER(r.name));
        DBMS_OUTPUT.PUT_LINE('SECTION    : ' || r.section || ' | Subject ' || v_current || ' of ' || v_total);
        DBMS_OUTPUT.PUT_LINE('=========================================================================================');
        DBMS_OUTPUT.PUT_LINE('COURSE : ' || r.subject_code || ' - ' || r.subject_name);
        DBMS_OUTPUT.PUT_LINE('PROF   : ' || r.professor);
        DBMS_OUTPUT.PUT_LINE('=========================================================================================');
        DBMS_OUTPUT.PUT_LINE(RPAD('SA',10)||RPAD('TA',10)||RPAD('SW',10)||RPAD('REC',10)||RPAD('FP',10)||RPAD('ME',10)||'FE');
        DBMS_OUTPUT.PUT_LINE(RPAD(r.sa,10)||RPAD(r.ta,10)||RPAD(r.sw,10)||RPAD(r.rec,10)||RPAD(r.fp,10)||RPAD(r.me,10)||r.fe);
        DBMS_OUTPUT.PUT_LINE('=========================================================================================');
        DBMS_OUTPUT.PUT_LINE(RPAD('MIDTERM',20)||RPAD('FINAL',20)||RPAD('GWA',20)||'STATUS');
        DBMS_OUTPUT.PUT_LINE(RPAD(TO_CHAR(v_midterm, '990'),20)||RPAD(TO_CHAR(v_final, '990'),20)||RPAD(TO_CHAR(v_gwa, '990'),20)||v_status);
        DBMS_OUTPUT.PUT_LINE('=========================================================================================');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No more subjects to display.');
    END IF;
    CLOSE c_item;
END;
/

PROMPT [1] Next Subject
PROMPT [2] Previous Subject
PROMPT [3] Go back to Student Menu

ACCEPT v_nav PROMPT 'What would you like to do next? '

SET TERMOUT OFF
COLUMN v_pos NEW_VALUE v_pos
COLUMN next_script NEW_VALUE v_script

SELECT 
    CASE '&v_nav'
        WHEN '1' THEN TO_CHAR(&v_pos + 1) 
        WHEN '2' THEN TO_CHAR(CASE WHEN &v_pos > 1 THEN &v_pos - 1 ELSE 1 END)
        ELSE TO_CHAR(&v_pos) 
    END AS v_pos,
    CASE '&v_nav'
        WHEN '3' THEN 'student_menu.sql'
        ELSE 'student_view_grades.sql'  
    END AS next_script
FROM dual;

UNDEFINE v_nav
SET TERMOUT ON

@&v_script