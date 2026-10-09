import java.sql.*;
import util.DbConnection;

public class TestDB {
    public static void main(String[] args) {
        try (Connection con = DbConnection.getConnection()) {
            String sql = "SELECT email, password, full_name FROM users WHERE role = 'MANAGER'";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                System.out.println("Email: " + rs.getString("email"));
                System.out.println("Name: " + rs.getString("full_name"));
                System.out.println("Hash: " + rs.getString("password"));
                System.out.println("-------------------------");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
