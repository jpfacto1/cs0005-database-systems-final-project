SET FEEDBACK OFF
SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
CL SCR

PROMPT =========================================================================================
PROMPT .                                  ADD STUDENT RECORD                                   .
PROMPT =========================================================================================

ACCEPT v_sid PROMPT '[Add Student Record] | Enter Student Number: '
ACCEPT v_name PROMPT '[Add Student Record] | Enter Full Name: '
ACCEPT v_sec PROMPT '[Add Student Record] | Enter Section (TN21-TN29): '

DECLARE
    v_id      VARCHAR2(50) := UPPER(TRIM('&v_sid'));
    v_name    VARCHAR2(100):= UPPER(TRIM('&v_name'));
    v_section VARCHAR2(10) := UPPER(TRIM('&v_sec'));
    v_check   NUMBER;
BEGIN
    IF v_section NOT LIKE 'TN2_' OR SUBSTR(v_section, 4, 1) NOT BETWEEN '1' AND '9' THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('=========================================================================================');
        DBMS_OUTPUT.PUT_LINE('[Error] Invalid Section. Only TN21 to TN29 are allowed.');
        DBMS_OUTPUT.PUT_LINE('=========================================================================================');
    ELSE
        SELECT COUNT(*) INTO v_check 
        FROM students 
        WHERE TRIM(student_id) = v_id;

        IF v_check > 0 THEN
            DBMS_OUTPUT.PUT_LINE(CHR(10));
            DBMS_OUTPUT.PUT_LINE('=========================================================================================');
            DBMS_OUTPUT.PUT_LINE('[Error] Student ID ' || v_id || ' already exists.');
            DBMS_OUTPUT.PUT_LINE('=========================================================================================');
        ELSE
            INSERT INTO students (student_id, name, section) 
            VALUES (v_id, v_name, v_section);
            COMMIT;

            DBMS_OUTPUT.PUT_LINE(CHR(10));
            DBMS_OUTPUT.PUT_LINE('=========================================================================================');
            DBMS_OUTPUT.PUT_LINE('Student ' || v_id || ' in section ' || v_section || ' added successfully.');
            DBMS_OUTPUT.PUT_LINE('=========================================================================================');
        END IF;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(CHR(10));
        DBMS_OUTPUT.PUT_LINE('=========================================================================================');
        DBMS_OUTPUT.PUT_LINE('[Error] ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('=========================================================================================');
END;
/

PAUSE Go back to previous menu?

UNDEFINE v_sid
UNDEFINE v_sec

@teacher_menu.sql