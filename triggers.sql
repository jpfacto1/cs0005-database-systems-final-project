-- triggers.sql

CREATE OR REPLACE TRIGGER trg_check_grade_range
BEFORE INSERT OR UPDATE ON grades
FOR EACH ROW
BEGIN
    IF :NEW.sa > 100 OR :NEW.ta > 100 OR :NEW.sw > 100 OR
       :NEW.rec > 100 OR :NEW.me > 100 OR :NEW.fe > 100 THEN
        RAISE_APPLICATION_ERROR(-20001, '[Trigger] Grades cannot be higher than 100.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_auto_calc_results
BEFORE UPDATE ON grades
FOR EACH ROW
DECLARE
    v_mid NUMBER;
    v_fin NUMBER;
BEGIN
    v_mid := fn_calculate_midterm(:NEW.sa, :NEW.ta, :NEW.sw, :NEW.rec, :NEW.me);
    v_fin := fn_calculate_final(:NEW.sa, :NEW.ta, :NEW.sw, :NEW.rec, :NEW.fp, :NEW.me, :NEW.fe);
   
    DBMS_OUTPUT.PUT_LINE('[Trigger] Recalculated results for Student. ' || :NEW.student_id);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, '[Trigger] Error. Check if function parameters match.');
END;
/

CREATE OR REPLACE TRIGGER trg_audit_student_delete
AFTER DELETE ON students
FOR EACH ROW
BEGIN
    INSERT INTO audits (log_message, log_date, db_user)
    VALUES ('[Trigger] Deleted Student ID: ' || :OLD.student_id, SYSDATE, USER);
END;
/