/* Aim : To study Cursors: (All types: Implicit, Explicit, Cursor FOR Loop, Parameterized Cursor) 

Problem Statement: Write a PL/SQL block of code using parameterized Cursor, that will merge the data 
available in the newly created table N_RollCall with the data available in the table O_Roll-call. If the data in 
the first table already exists in the second table then that data should be skipped. 
PREREQUISITE:Knowledge of PL/SQL block  */

CREATE TABLE Old_records (
		roll_no INT (10),
        name VARCHAR (20)
);

CREATE TABLE new_records (
	roll_no INT (10),
    name VARCHAR (20)
);

INSERT INTO Old_records (roll_no, name)
VALUES
(101, 'Pratik'),
(102, 'Rohit'),
(103, 'Ananya'),
(104, 'Riya'),
(105, 'Amit'),
(106, 'Sanjay'),
(107, 'Meera'),
(108, 'Akash'),
(109, 'Pooja'),
(110, 'Vikram');

INSERT INTO new_records (roll_no, name)
VALUES 
(107, 'Meera'),
(108, 'Akash'),
(103, 'Ananya')
;

SELECT * FROM new_records;

DELIMITER $$

DECLARE 
	v_rollno_ old_records.roll_no %TYPE;
    v_name old_records.name %TYPE;
    
    CURSOR C1 IS
		SELECT roll_no, name
        FROM old_records
        WHERE roll_no NOT IN (roll_no IN new_records);

BEGIN 
	 OPEN C1;
     LOOP 
		FETCH C1 INTO v_rollno, v_name;
        
        EXIT WHEN C1 %NOTFOUND;
        
        INSERT INTO new_records (roll_no, name)
        VALUES
        (v_rollno, v_name);
        
        DBMS_OUTPUT.PUT_LINE ('Inserted Roll No. :' || v_roll_no || ', Name:' || v_name);
      END LOOP;
      
      CLOSE C1;
      
END;
/        
DELIMITER ;

SELECT * FROM new_records;
