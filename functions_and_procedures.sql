-- functions_and_procedures.sql

CREATE OR REPLACE FUNCTION fn_calculate_midterm(
    p_sa NUMBER, p_ta NUMBER, p_sw NUMBER, p_rec NUMBER, p_me NUMBER
) RETURN NUMBER IS
    v_avg NUMBER;
BEGIN
    v_avg := (p_sa + p_ta + p_sw + p_rec) / 4;
    RETURN ROUND((0.6 * v_avg) + (0.4 * p_me));
END;
/

CREATE OR REPLACE FUNCTION fn_calculate_final(
    p_sa NUMBER, p_ta NUMBER, p_sw NUMBER, p_rec NUMBER, p_fp NUMBER, p_me NUMBER, p_fe NUMBER
) RETURN NUMBER IS
    v_avg NUMBER;
BEGIN
    v_avg := (p_sa + p_ta + p_sw + p_rec + p_fp) / 5;
    RETURN ROUND((0.6 * v_avg) + (0.15 * p_me) + (0.25 * p_fe));
END;
/

CREATE OR REPLACE FUNCTION fn_calculate_gwa(p_mid IN NUMBER, p_fin IN NUMBER)
RETURN NUMBER IS
BEGIN
    RETURN ROUND((p_mid + p_fin) / 2);
END;
/

CREATE OR REPLACE FUNCTION fn_get_status(p_gwa IN NUMBER)
RETURN VARCHAR2 IS
BEGIN
    IF p_gwa >= 70 THEN
        RETURN 'PASSED';
    ELSE
        RETURN 'FAILED';
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE update_all_grades AS
BEGIN
    UPDATE grades
    SET me = fn_calculate_midterm(sa, ta, sw, rec, me);

    UPDATE grades
    SET fe = fn_calculate_final(sa, ta, sw, rec, fp, me, fe);
   
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('All Grades have been updated successfully.');
END;
/

CREATE OR REPLACE PROCEDURE add_student (
    p_sid IN VARCHAR2,
    p_sec IN VARCHAR2
) AS
BEGIN
    INSERT INTO students (student_id, name, section) 
    VALUES (TRIM(p_sid), 'NEW STUDENT', UPPER(TRIM(p_sec)));
END;
/

CREATE OR REPLACE PROCEDURE add_teacher(
    p_full_name IN VARCHAR2,
    p_scode     IN VARCHAR2
) AS
    v_first_init     VARCHAR2(2);
    v_last_name      VARCHAR2(50);
    v_generated_user VARCHAR2(20);
    v_generated_pass VARCHAR2(30);
    v_check_subj     NUMBER;
BEGIN
    v_first_init := LOWER(SUBSTR(p_full_name, 1, 1)) || LOWER(SUBSTR(p_full_name, 1, 1));
    v_last_name  := LOWER(SUBSTR(p_full_name, INSTR(p_full_name, ' ', -1) + 1));
    v_generated_user := v_first_init || v_last_name;
    v_generated_pass := 'prof_' || v_generated_user;

    SELECT COUNT(*) INTO v_check_subj FROM subjects WHERE subject_code = UPPER(p_scode);

    IF v_check_subj = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[Error] Subject Code ' || p_scode || ' is invalid.');
    ELSE
        INSERT INTO teachers (username, name, password)
        VALUES (v_generated_user, p_full_name, v_generated_pass);

        UPDATE subjects
        SET professor = p_full_name
        WHERE subject_code = UPPER(p_scode);

        COMMIT;
       
        DBMS_OUTPUT.PUT_LINE('========================================================');
        DBMS_OUTPUT.PUT_LINE('Professor Added Successfully.');
        DBMS_OUTPUT.PUT_LINE('Username : ' || v_generated_user);
        DBMS_OUTPUT.PUT_LINE('Password : ' || v_generated_pass);
        DBMS_OUTPUT.PUT_LINE('Assigned Subject : ' || UPPER(p_scode));
        DBMS_OUTPUT.PUT_LINE('========================================================');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[Error] Registration failed. Check name format or duplicate user.');
        ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE add_subject(
    p_scode IN VARCHAR2,
    p_sname IN VARCHAR2
) AS
    v_check NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_check FROM subjects WHERE subject_code = UPPER(p_scode);

    IF v_check > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[Error] Subject Code [' || UPPER(p_scode) || '] already exists.');
    ELSE
        INSERT INTO subjects (subject_code, subject_name, professor)
        VALUES (UPPER(p_scode), UPPER(p_sname), 'TBA');

        INSERT INTO grades (student_id, subject_code, sa, ta, sw, rec, fp, me, fe)
        SELECT student_id, UPPER(p_scode), 0, 0, 0, 0, 0, 0, 0 FROM students;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Subject ' || UPPER(p_sname) || ' (' || UPPER(p_scode) || ') Added Successfully.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[Error] Subject not added successfully.');
        ROLLBACK;
END;
/