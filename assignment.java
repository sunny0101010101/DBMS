import java.sql.*;

public class assignment {

    // Database credentials
    static final String DB_URL = "jdbc:mysql://localhost:3306/college";  // Replace 'school' with your DB name
    static final String USER = "root";  // Replace with your MySQL username
    static final String PASS = "*****";  // Replace with your MySQL password

    public static void main(String[] args) {
        try {
            // 1. Register JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Open a connection
            Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
            Statement stmt = conn.createStatement();

            // 1. Create table Stud with ID, name, marks columns
            String createTableSQL = "CREATE TABLE IF NOT EXISTS Stud (" +
                    "ID INT PRIMARY KEY AUTO_INCREMENT," +
                    "name VARCHAR(50)," +
                    "marks INT)";
            stmt.executeUpdate(createTableSQL);
            System.out.println("Table Stud created successfully!");

            // 2. Insert 5 records in Stud
            String insertRecordsSQL = "INSERT INTO Stud (name, marks) VALUES " +
                    "('Pratik', 51), " +
                    "('Shridhar', 45), " +
                    "('Neel', 60), " +
                    "('Ansh', 70), " +
                    "('Shlok', 80)";
            stmt.executeUpdate(insertRecordsSQL);
            System.out.println("5 records inserted!");

            // 3. Update marks to 50 for student with ID = 3
            String updateMarksSQL = "UPDATE Stud SET marks = 50 WHERE ID = 3";
            stmt.executeUpdate(updateMarksSQL);
            System.out.println("Updated marks for student with ID = 3!");

            // 4. Delete record for student whose ID is 1
            String deleteRecordSQL = "DELETE FROM Stud WHERE ID = 1";
            stmt.executeUpdate(deleteRecordSQL);
            System.out.println("Deleted student with ID = 1!");

            // 5. Alter table stud to add a new column dept
            String alterTableAddSQL = "ALTER TABLE Stud ADD dept VARCHAR(50)";
            stmt.executeUpdate(alterTableAddSQL);
            System.out.println("Added new column dept to the table!");

            // 6. Alter table stud to modify the column dept (change its size)
            String modifyDeptSQL = "ALTER TABLE Stud MODIFY dept VARCHAR(100)";
            stmt.executeUpdate(modifyDeptSQL);
            System.out.println("Modified column dept!");

            // 7. Alter table stud and drop the column dept
            String dropDeptSQL = "ALTER TABLE Stud DROP COLUMN dept";
            stmt.executeUpdate(dropDeptSQL);
            System.out.println("Dropped column dept!");

            // Close connections
            stmt.close();
            conn.close();

        } catch (SQLException | ClassNotFoundException se) {
            se.printStackTrace();
        }
    }
}
 
