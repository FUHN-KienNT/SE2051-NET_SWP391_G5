import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.PreparedStatement;

public class TestDB {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=courson_db;encrypt=true;trustServerCertificate=true";
        String user = "sa";
        String pass = "CHANGE_ME";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Connected to DB!");
            
            // 1. Drop existing constraint
            try {
                stmt.execute("ALTER TABLE courses DROP CONSTRAINT chk_courses_status");
                System.out.println("Dropped chk_courses_status");
            } catch (Exception e) {
                System.out.println("Constraint may not exist: " + e.getMessage());
            }

            // 2. Add new constraint with PENDING_REVIEW
            try {
                stmt.execute("ALTER TABLE courses ADD CONSTRAINT chk_courses_status CHECK (status IN ('DRAFT','PENDING_REVIEW','PUBLISHED','ARCHIVED'))");
                System.out.println("Added chk_courses_status with PENDING_REVIEW");
            } catch (Exception e) {
                System.out.println("Failed to add constraint: " + e.getMessage());
            }

            // 3. Insert mock courses
            String insertSql = "INSERT INTO courses (title, category_id, description, price, status, manager_id, expert_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
                
                // Course 1
                pstmt.setString(1, "Khóa học ReactJS Thực chiến");
                pstmt.setLong(2, 6); // Web Dev
                pstmt.setString(3, "Xây dựng ứng dụng web hiện đại với ReactJS, Redux, và Hooks.");
                pstmt.setBigDecimal(4, new java.math.BigDecimal("850000.00"));
                pstmt.setString(5, "PUBLISHED");
                pstmt.setLong(6, 2); // manager1
                pstmt.setLong(7, 3); // expert1
                pstmt.addBatch();

                // Course 2
                pstmt.setString(1, "Nhập môn Machine Learning với Python");
                pstmt.setLong(2, 7); // Data AI
                pstmt.setString(3, "Học cách xây dựng mô hình học máy cơ bản bằng Scikit-Learn.");
                pstmt.setBigDecimal(4, new java.math.BigDecimal("1200000.00"));
                pstmt.setString(5, "DRAFT");
                pstmt.setLong(6, 2);
                pstmt.setNull(7, java.sql.Types.BIGINT);
                pstmt.addBatch();

                // Course 3
                pstmt.setString(1, "Kỹ năng thuyết trình trước đám đông");
                pstmt.setLong(2, 8); // Soft skills
                pstmt.setString(3, "Làm chủ sân khấu, tự tin giao tiếp và truyền đạt thông điệp hiệu quả.");
                pstmt.setBigDecimal(4, new java.math.BigDecimal("0"));
                pstmt.setString(5, "PENDING_REVIEW");
                pstmt.setLong(6, 2);
                pstmt.setLong(7, 3);
                pstmt.addBatch();

                // Course 4
                pstmt.setString(1, "Khóa học NodeJS căn bản (Archived)");
                pstmt.setLong(2, 6); // Web
                pstmt.setString(3, "Xây dựng API RESTful với ExpressJS và MongoDB. (Khóa học đã đóng)");
                pstmt.setBigDecimal(4, new java.math.BigDecimal("500000.00"));
                pstmt.setString(5, "ARCHIVED");
                pstmt.setLong(6, 2);
                pstmt.setLong(7, 3);
                pstmt.addBatch();

                pstmt.executeBatch();
                System.out.println("Inserted 4 mock courses successfully!");
            } catch (Exception e) {
                System.out.println("Failed to insert mock courses: " + e.getMessage());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
