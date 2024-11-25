-- Create the borrower table
CREATE TABLE borrower (
    Rollin INT PRIMARY KEY, 
    Name VARCHAR(50),
    DateOfIssue DATE,
    NameOfBook VARCHAR(50),
    Status CHAR(1) CHECK (Status IN ('I', 'R')) -- Ensures only 'I' (Issued) or 'R' (Returned)
);

-- Create the Fine table
CREATE TABLE Fine (
    Roll_no INT, -- Allows multiple fines for the same Roll_no
    Date DATE,
    Amt DECIMAL(10,2), -- MySQL uses DECIMAL for fixed-point numbers
    FOREIGN KEY (Roll_no) REFERENCES borrower (Rollin)
);

-- Insert sample data into borrower table
INSERT INTO borrower (Rollin, Name, DateOfIssue, NameOfBook, Status)
VALUES 
(101, 'Pratik Dhage', '2024-10-08', 'Theory Of Computation', 'I'),
(102, 'Rohit Sharma', '2024-10-09', 'Database Systems', 'R'),
(103, 'Ananya Singh', '2024-10-10', 'Artificial Intelligence', 'I'),
(104, 'Riya Patel', '2024-10-11', 'Data Structures and Algorithms', 'R'),
(105, 'Amit Kumar', '2024-10-12', 'Operating Systems', 'I'),
(106, 'Sanjay Joshi', '2024-10-13', 'Computer Networks', 'R'),
(107, 'Meera Nair', '2024-10-14', 'Software Engineering', 'I'),
(108, 'Akash Verma', '2024-10-15', 'Machine Learning', 'R'),
(109, 'Pooja Reddy', '2024-10-16', 'Cybersecurity Basics', 'I'),
(110, 'Vikram Singh', '2024-10-17', 'Discrete Mathematics', 'R'),
(111, 'Sneha Sharma', '2024-10-18', 'Cloud Computing', 'I'),
(112, 'Arjun Mehta', '2024-10-19', 'Big Data Analytics', 'R'),
(113, 'Kriti Malhotra', '2024-10-20', 'Blockchain Basics', 'I'),
(114, 'Varun Das', '2024-10-21', 'Quantum Computing', 'R'),
(115, 'Neha Choudhary', '2024-10-22', 'Python Programming', 'I'),
(116, 'Yash Gupta', '2024-10-23', 'Java Fundamentals', 'R'),
(117, 'Aisha Khan', '2024-10-24', 'Artificial Neural Networks', 'I'),
(118, 'Rajesh Kumar', '2024-10-25', 'Cyber Forensics', 'R'),
(119, 'Ishita Roy', '2024-10-26', 'Cryptography', 'I'),
(120, 'Kunal Jain', '2024-10-27', 'Computer Graphics', 'R');

-- Set DELIMITER to avoid issues with semicolons in the procedure body
DELIMITER $$

CREATE PROCEDURE ReturnBook (
    IN v_roll_no INT, 
    IN v_book_name VARCHAR(50)
)
BEGIN
    DECLARE v_date_of_issue DATE;
    DECLARE v_status CHAR(1);
    DECLARE v_days INT;
    DECLARE v_fine_amt DECIMAL(10,2) DEFAULT 0;

    -- Fetch the DateOfIssue and Status of the book for the given roll_no and book name
    SELECT DateOfIssue, Status
    INTO v_date_of_issue, v_status
    FROM borrower
    WHERE Rollin = v_roll_no AND NameOfBook = v_book_name;

    -- Check if the book is currently issued (Status = 'I')
    IF v_status = 'I' THEN
        -- Calculate the number of days since the book was issued
        SET v_days = DATEDIFF(CURRENT_DATE, v_date_of_issue);
        
        -- Determine the fine amount based on the number of days
        IF v_days > 15 AND v_days <= 30 THEN
            SET v_fine_amt = (v_days - 15) * 5; -- Rs. 5 per day for days between 15 and 30
        ELSEIF v_days > 30 THEN
            SET v_fine_amt = (15 * 5) + ((v_days - 30) * 50); -- Rs. 50 per day for days > 30
        END IF;
        
        -- Update the status of the book to 'R' (Returned)
        UPDATE borrower
        SET Status = 'R'
        WHERE Rollin = v_roll_no AND NameOfBook = v_book_name;

        -- Insert fine details into the Fine table if applicable
        IF v_fine_amt > 0 THEN
            INSERT INTO Fine (Roll_no, Date, Amt)
            VALUES (v_roll_no, CURRENT_DATE, v_fine_amt);
        END IF;
    ELSE
        SELECT 'The book has already been returned or does not exist.' AS Message;
    END IF;
END $$

-- Reset DELIMITER to semicolon after procedure definition
DELIMITER ;


-- Call the procedure to return a book and calculate the fine
CALL ReturnBook(101, 'Theory Of Computation');


