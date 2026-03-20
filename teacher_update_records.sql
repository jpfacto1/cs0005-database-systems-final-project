-- teacher_update_records.sql

SET FEEDBACK OFF
SET VERIFY OFF
SET SERVEROUTPUT ON
CL SCR

PROMPT =========================================================================================
PROMPT .                                     UPDATE RECORDS                                    .
PROMPT =========================================================================================

-- Reference List
COLUMN student_id FORMAT A15 HEADING 'ID NUMBER'
COLUMN name       FORMAT A30 HEADING 'STUDENT NAME'
SELECT student_id, name FROM students ORDER BY name;

PROMPT
ACCEPT v_sid PROMPT '[Update Records] | Enter Student ID: '

-- Fetch Name quietly
COLUMN name NEW_VALUE v_sname DEFAULT 'NOT_FOUND'
SET TERMOUT OFF
SELECT name FROM students WHERE student_id = '&v_sid';
SET TERMOUT ON

-- Check if we should RETRY or PROCEED
COLUMN action_cmd NEW_VALUE v_run_script
SET TERMOUT OFF
SELECT CASE 
         WHEN '&v_sname' = 'NOT_FOUND' THEN '@teacher_update_records.sql' 
         ELSE 'PROMPT ID Verified...' 
       END AS action_cmd 
FROM dual;
SET TERMOUT ON

-- Error Message for the User
BEGIN
    IF '&v_sname' = 'NOT_FOUND' THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '>>> ERROR: Student ID [&v_sid] not found!');
        DBMS_OUTPUT.PUT_LINE('>>> Restarting update process... Please wait.');
    END IF;
END;
/

-- If the ID was NOT_FOUND, this will UNDEFINE and RESTART the script
-- If the ID was FOUND, this will do nothing and continue
SET TERMOUT OFF
COLUMN undef_cmd NEW_VALUE v_undef
SELECT DECODE('&v_sname', 'NOT_FOUND', 'UNDEFINE v_sid', 'PROMPT Continuing...') AS undef_cmd FROM dual;
SET TERMOUT ON

&v_undef
&v_run_script

-- =============================================================================================
-- ALL CODE BELOW ONLY EXECUTES IF v_sname IS NOT 'NOT_FOUND'
-- =============================================================================================

PROMPT STUDENT NAME   : &v_sname
PROMPT STUDENT NUMBER : &v_sid
PROMPT
PROMPT ENROLLED SUBJECTS
PROMPT =========================================================================================
SELECT subject_code FROM grades WHERE student_id = '&v_sid';
PROMPT =========================================================================================

ACCEPT v_scode PROMPT '[Update Records] | Enter Subject Code to Update: '

PROMPT
PROMPT CURRENT GRADES FOR &v_scode
PROMPT =========================================================================================
COLUMN sa  FORMAT 999
COLUMN ta  FORMAT 999
COLUMN sw  FORMAT 999
COLUMN rec FORMAT 999
COLUMN me  FORMAT 999
COLUMN fp  FORMAT 999
COLUMN fe  FORMAT 999

SELECT sa, ta, sw, rec, me, fp, fe 
FROM grades 
WHERE student_id = '&v_sid' AND UPPER(subject_code) = UPPER('&v_scode');
PROMPT =========================================================================================

ACCEPT v_sa  NUMBER PROMPT 'New SA  : '
ACCEPT v_ta  NUMBER PROMPT 'New TA  : '
ACCEPT v_sw  NUMBER PROMPT 'New SW  : '
ACCEPT v_rec NUMBER PROMPT 'New REC : '
ACCEPT v_me  NUMBER PROMPT 'New ME  : '
ACCEPT v_fp  NUMBER PROMPT 'New FP  : '
ACCEPT v_fe  NUMBER PROMPT 'New FE  : '

BEGIN
    UPDATE grades
    SET sa = &v_sa, ta = &v_ta, sw = &v_sw, rec = &v_rec,
        me = &v_me, fp = &v_fp, fe = &v_fe
    WHERE student_id = '&v_sid' AND UPPER(subject_code) = UPPER('&v_scode');

    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Grades successfully updated.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '>>> [Error] Subject Code not found for this student.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '>>> [Error] ' || SQLERRM);
END;
/

PROMPT
PROMPT UPDATED GRADES SUMMARY
PROMPT =========================================================================================
SELECT 
    sa, ta, sw, rec, me, fp, fe,
    ROUND(fn_calculate_gwa(
        fn_calculate_midterm(sa, ta, sw, rec, me),
        fn_calculate_final(sa, ta, sw, rec, fp, me, fe)
    )) AS "NEW_GWA"
FROM grades 
WHERE student_id = '&v_sid' AND UPPER(subject_code) = UPPER('&v_scode');
PROMPT =========================================================================================

PROMPT
PAUSE Press ENTER to return to Teacher Menu...

UNDEFINE v_sid
UNDEFINE v_sname
UNDEFINE v_scode
UNDEFINE v_sa
UNDEFINE v_ta
UNDEFINE v_sw
UNDEFINE v_rec
UNDEFINE v_me
UNDEFINE v_fp
UNDEFINE v_fe
UNDEFINE v_run_script
UNDEFINE v_undef

@teacher_menu.sql