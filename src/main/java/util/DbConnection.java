package util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DbConnection {
    private static String URL = "jdbc:sqlserver://localhost:1433;databaseName=courson_db;encrypt=true;trustServerCertificate=true";
    private static String USER = "sa";
    private static String PASSWORD = "CHANGE_ME";

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (InputStream is = DbConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (is != null) {
                    Properties prop = new Properties();
                    prop.load(is);
                    if (prop.containsKey("db.url")) URL = prop.getProperty("db.url");
                    if (prop.containsKey("db.user")) USER = prop.getProperty("db.user");
                    if (prop.containsKey("db.password")) PASSWORD = prop.getProperty("db.password");
                }
            } catch (Exception ignored) {
            }
            if (System.getenv("DB_URL") != null) URL = System.getenv("DB_URL");
            if (System.getenv("DB_USER") != null) USER = System.getenv("DB_USER");
            if (System.getenv("DB_PASSWORD") != null) PASSWORD = System.getenv("DB_PASSWORD");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("SQL Server JDBC Driver not found", e);
        }
    }

    private DbConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void rollbackQuietly(Connection con) {
        if (con != null) {
            try {
                con.rollback();
            } catch (SQLException ignored) {
            }
        }
    }

    public static void closeQuietly(AutoCloseable resource) {
        if (resource != null) {
            try {
                resource.close();
            } catch (Exception ignored) {
            }
        }
    }
}
