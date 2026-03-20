-- tables.sql

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE grades CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE subjects CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE students CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE teachers CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE audits CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE teachers (
    username   VARCHAR2(15) PRIMARY KEY,
    name       VARCHAR2(100),
    password   VARCHAR2(20)
);

CREATE TABLE students (
    student_id VARCHAR2(15) PRIMARY KEY,
    name       VARCHAR2(100),
    section    VARCHAR2(10),
    password   VARCHAR2(20)
);

CREATE TABLE subjects (
    subject_code VARCHAR2(15) PRIMARY KEY,
    subject_name VARCHAR2(100),
    professor    VARCHAR2(50)
);

CREATE TABLE grades (
    student_id   VARCHAR2(15),
    subject_code VARCHAR2(15),
    sa NUMBER, ta NUMBER, sw NUMBER, rec NUMBER, fp NUMBER,
    me NUMBER, fe NUMBER,
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES students(student_id),
    CONSTRAINT fk_subject FOREIGN KEY (subject_code) REFERENCES subjects(subject_code)
);

CREATE TABLE audits (
    log_id      NUMBER PRIMARY KEY,
    log_message VARCHAR2(4000),
    log_date    DATE,
    db_user     VARCHAR2(100)
);