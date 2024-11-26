
USE practical_preperation;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS old_records;
DROP TABLE IF EXISTS new_records;

-- Create the Old_records table
CREATE TABLE IF NOT EXISTS old_records (
    roll_no INT(10),
    name VARCHAR(20)
);

-- Create the New_records table
CREATE TABLE IF NOT EXISTS new_records (
    roll_no INT(10),
    name VARCHAR(20)
);

-- Insert sample data into Old_records
INSERT INTO old_records (roll_no, name) 
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

-- Insert sample data into New_records
INSERT INTO new_records (roll_no, name)
VALUES 
(107, 'Meera'),
(108, 'Akash'),
(103, 'Ananya');

-- Verify the initial content of New_records
SELECT * FROM new_records;

-- Create a stored procedure to merge records
DELIMITER $$

CREATE PROCEDURE merge_records()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_rollno INT;
    DECLARE v_name VARCHAR(20);

    -- Declare a cursor for selecting records not in New_records
    DECLARE cur CURSOR FOR
        SELECT roll_no, name
        FROM old_records
        WHERE roll_no NOT IN (SELECT roll_no FROM new_records);

    -- Declare a handler to manage cursor end
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN cur;

    -- Loop through the cursor
    read_loop: LOOP
        FETCH cur INTO v_rollno, v_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insert records into New_records
        INSERT INTO new_records (roll_no, name)
        VALUES (v_rollno, v_name);

        -- Optionally, output inserted records (requires session support for output)
        SELECT CONCAT('Inserted Roll No.: ', v_rollno, ', Name: ', v_name) AS message;
    END LOOP;

    -- Close the cursor
    CLOSE cur;
END$$

DELIMITER ;

-- Call the stored procedure
CALL merge_records();

-- Verify the content of New_records after merging
SELECT * FROM new_records;
