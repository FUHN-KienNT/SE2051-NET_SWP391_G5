package service;

import util.DbConnection;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DevSeedService {
    private static final Logger LOGGER = Logger.getLogger(DevSeedService.class.getName());

    public static synchronized boolean resetMasterSeed() {
        String sql = loadSeedSql();
        if (sql == null || sql.trim().isEmpty()) {
            LOGGER.severe("Không thể tìm thấy hoặc đọc file seed_test_master.sql!");
            return false;
        }

        try (Connection con = DbConnection.getConnection();
             Statement stmt = con.createStatement()) {
            LOGGER.info("[DEV SEED RESET] Bắt đầu khôi phục dữ liệu kiểm thử (Master Testing Seed)...");
            stmt.execute(sql);
            LOGGER.info("[DEV SEED RESET] Khôi phục Master Testing Seed thành công!");
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[DEV SEED RESET] Lỗi thực thi Master Testing Seed: " + e.getMessage(), e);
            return false;
        }
    }

    private static String loadSeedSql() {
        // 1. Thử load từ Classpath resource
        try (InputStream is = DevSeedService.class.getClassLoader().getResourceAsStream("database/seed_test_master.sql")) {
            if (is != null) {
                return readStream(is);
            }
        } catch (Exception ignored) {
        }

        // 2. Thử load từ đường dẫn file cục bộ trong dự án
        Path[] candidatePaths = new Path[]{
            Paths.get("database/seed_test_master.sql"),
            Paths.get("d:/LMHT/SWP/SE2051-NET_SWP391_G5/database/seed_test_master.sql"),
            Paths.get("d:/LMHT/SWP/SE2051-NET_SWP391_G5/src/main/resources/database/seed_test_master.sql")
        };

        for (Path p : candidatePaths) {
            try {
                if (Files.exists(p)) {
                    return Files.readString(p, StandardCharsets.UTF_8);
                }
            } catch (Exception ignored) {
            }
        }

        return null;
    }

    private static String readStream(InputStream is) throws Exception {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line).append("\n");
            }
        }
        return sb.toString();
    }
}
