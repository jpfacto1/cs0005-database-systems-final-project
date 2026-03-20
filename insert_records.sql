-- insert_records.sql

INSERT INTO subjects VALUES ('CS0021', 'DISCRETE STRUCTURES', 'Marilyn Sanchez');
INSERT INTO subjects VALUES ('CS0017', 'OPERATING SYSTEM', 'Jeneffer Sabonsolin');
INSERT INTO subjects VALUES ('CS0010', 'FUNDAMENTALS OF ANALYTICS', 'Anthony Aquino');
INSERT INTO subjects VALUES ('CS0005', 'DATABASE SYSTEMS', 'Fanny Almeniana');
INSERT INTO subjects VALUES ('CS0007', 'ALGORITHM', 'Justine Jude Pura');
INSERT INTO subjects VALUES ('CCS0101', 'DESIGN THINKING', 'May Florence San Pablo');

INSERT INTO teachers VALUES ('mmsanchez', 'Marilyn Sanchez', 'prof_mmsanchez');
INSERT INTO teachers VALUES ('jjsabonsolin', 'Jeneffer Sabonsolin', 'prof_jjsabonsolin');
INSERT INTO teachers VALUES ('aaaquino', 'Anthony Aquino', 'prof_aaaquino');
INSERT INTO teachers VALUES ('ffalmeniana', 'Fanny Almeniana', 'prof_ffalmeniana');
INSERT INTO teachers VALUES ('jjpura', 'Justine Jude Pura', 'prof_jjpura');
INSERT INTO teachers VALUES ('mmsanpablo', 'May Florence San Pablo', 'prof_mmsanpablo');

DECLARE
    TYPE t_name IS TABLE OF VARCHAR2(50);
    v_fn t_name := t_name(
        'Aaron','Abigail','Adrian','Aileen','Albert','Alex','Alicia','Alvin','Amanda','Andrew',
        'Angela','Angelo','Anita','Anthony','Arlene','Arnold','Arthur','Beatrice','Benjie','Bernadette',
        'Bethany','Bianca','Bobby','Brenda','Bryan','Camille','Carl','Carmen','Cedric','Celine',
        'Charles','Chloe','Chris','Clara','Claude','Cynthia','Daisy','Daniel','Dante','Daphne',
        'David','Debbie','Dennis','Diana','Diego','Dominic','Donna','Edgar','Edith','Eduardo',
        'Edwin','Elaine','Eleanor','Elias','Elisa','Elizabeth','Ellen','Elmer','Elsa','Emmanuel',
        'Eric','Erica','Esther','Eugene','Eunice','Eva','Evelyn','Felix','Ferdinand','Fernando',
        'Fiona','Flora','Florence','Francis','Fred','Gabriel','Gemma','George','Gerald','Gina',
        'Gloria','Grace','Gregorio','Hannah','Harold','Hazel','Hector','Helen','Henry','Herbert',
        'Herman','Homer','Ida','Ignacio','Imelda','Irene','Iris','Isaac','Isabel','Isidro'
    );

    v_ln t_name := t_name(
        'Abad','Abalos','Abaya','Abril','Agoncillo','Aguinaldo','Alcasid','Almazan','Almeda','Alonzo',
        'Alvarado','Alvarez','Amante','Andrada','Angeles','Antipolo','Apostol','Aragon','Araneta','Arceo',
        'Arellano','Arnaiz','Arroyo','Asis','Atienza','Austria','Balagtas','Baluyot','Banayo','Barretto',
        'Basco','Belmonte','Benitez','Bernardo','Blanco','Bonifacio','Borja','Buenaventura','Buencamino','Burgos',
        'Caballero','Cabanatuan','Cabrera','Cacho','Calaguas','Calderon','Calungsod','Campos','Canlas','Caparas',
        'Carreon','Castillo','Castro','Catacutan','Cayetano','Cervantes','Chu','Claudio','Co','Concepcion',
        'Constantino','Coronel','Cortez','Crisostomo','Cruz','Cuenco','Cunanan','Custodio','Dagohoy','Dandan',
        'David','Dayrit','De Guzman','De Jesus','De Leon','De Mesa','Del Rosario','Delos Reyes','Delos Santos','Diamante',
        'Diaz','Dilangalen','Dimaculangan','Dimalanta','Dimasalang','Diokno','Domingo','Dominguez','Dorado','Dumlao',
        'Echeverria','Ejercito','Encarnacion','Enrile','Enriquez','Escudero','Esguerra','Espina','Espinosa','Espiritu'
    );

    v_sid VARCHAR2(15);
BEGIN
    FOR i IN 1..100 LOOP
        v_sid := '2024' || TRUNC(DBMS_RANDOM.VALUE(10000,99999));
       
        INSERT INTO students VALUES (
            v_sid,
            UPPER(v_fn(i) || ' ' || v_ln(i)),
            'TN2' || TRUNC(DBMS_RANDOM.VALUE(1,10)),
            v_sid
        );

        FOR r_sub IN (SELECT subject_code FROM subjects) LOOP
            INSERT INTO grades VALUES (
                v_sid,
                r_sub.subject_code,
                TRUNC(DBMS_RANDOM.VALUE(50,98)),
                TRUNC(DBMS_RANDOM.VALUE(50,98)),
                TRUNC(DBMS_RANDOM.VALUE(50,98)),
                TRUNC(DBMS_RANDOM.VALUE(50,98)),
                TRUNC(DBMS_RANDOM.VALUE(50,98)),
                TRUNC(DBMS_RANDOM.VALUE(50,98)),
                TRUNC(DBMS_RANDOM.VALUE(50,98))
            );
        END LOOP;
    END LOOP;
    COMMIT;
END;
/

PROMPT Records Inserted Successfully.