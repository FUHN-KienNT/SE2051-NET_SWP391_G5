package test;

import dao.PasswordResetTokenDao;
import dao.UserDao;
import entity.PasswordResetToken;
import entity.User;
import service.PasswordResetService;
import service.ValidationException;
import util.DbConnection;
import util.PasswordUtil;
import util.TokenUtil;
import util.ValidationUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class AuthAndResetTestSuite {

    private static final UserDao userDao = new UserDao();
    private static final PasswordResetTokenDao tokenDao = new PasswordResetTokenDao();
    private static final PasswordResetService resetService = new PasswordResetService(userDao, tokenDao);

    private static int totalPassed = 0;
    private static int totalFailed = 0;
    private static final List<String> failures = new ArrayList<>();

    @org.junit.jupiter.api.Test
    @org.junit.jupiter.api.DisplayName("Bộ kiểm thử Nghiệp vụ Xác thực & Đặt lại mật khẩu")
    public void testAuthAndResetSuite() {
        totalPassed = 0;
        totalFailed = 0;
        failures.clear();

        try {
            testTokenUtil();
            testPasswordStrengthValidation();
            testTokenDaoOperations();
            testPasswordResetServiceFlow();
            testResetPasswordExecution();
        } catch (Exception e) {
            recordFailure("Lỗi ngoại lệ: " + e.getMessage());
        }

        if (totalFailed > 0) {
            org.junit.jupiter.api.Assertions.fail("Có " + totalFailed + " ca kiểm thử thất bại: " + String.join(", ", failures));
        }
    }

    public static void main(String[] args) {
        System.out.println("======================================================================");
        System.out.println("     COURSON LMS - KIỂM THỬ XÁC THỰC VÀ ĐẶT LẠI MẬT KHẨU (RESET PW)   ");
        System.out.println("======================================================================\n");

        try {
            testTokenUtil();
            testPasswordStrengthValidation();
            testTokenDaoOperations();
            testPasswordResetServiceFlow();
            testResetPasswordExecution();
        } catch (Exception e) {
            e.printStackTrace();
            recordFailure("Lỗi ngoại lệ không lường trước trong quá trình test: " + e.getMessage());
        }

        System.out.println("\n======================================================================");
        System.out.println(String.format(" KẾT QUẢ KIỂM THỬ: %d THÀNH CÔNG, %d THẤT BẠI", totalPassed, totalFailed));
        System.out.println("======================================================================");

        if (totalFailed > 0) {
            System.out.println("DANH SÁCH TEST CASE THẤT BẠI:");
            for (String f : failures) {
                System.out.println(" [!] " + f);
            }
            System.exit(1);
        } else {
            System.out.println(" TẤT CẢ KIỂM THỬ XÁC THỰC & RESET PASSWORD ĐỀU ĐẠT CHUẨN 100%!");
        }
    }

    private static void testTokenUtil() {
        System.out.println("--- 1. Kiểm thử TokenUtil & Hash ---");

        // 1.1 Generate token
        String token1 = TokenUtil.generateToken();
        String token2 = TokenUtil.generateToken();
        assertCondition(token1 != null && token1.length() >= 40, "TokenUtil.generateToken sinh chuỗi Base64 độ dài chuẩn");
        assertCondition(!token1.equals(token2), "TokenUtil sinh token ngẫu nhiên không trùng lặp");

        // 1.2 Hash token
        String hash1 = TokenUtil.hashToken(token1);
        assertCondition(hash1 != null && hash1.length() == 64, "TokenUtil.hashToken sinh SHA-256 64 ký tự hex");
        assertCondition(hash1.equals(TokenUtil.hashToken(token1)), "TokenUtil.hashToken mang tính tất định (deterministic)");
        assertCondition(!hash1.equals(TokenUtil.hashToken(token2)), "Token khác nhau cho ra hash khác nhau");

        // 1.3 Null/Empty validation
        try {
            TokenUtil.hashToken("");
            recordFailure("TokenUtil.hashToken rỗng phải ném IllegalArgumentException");
        } catch (IllegalArgumentException e) {
            recordPass("TokenUtil.hashToken từ chối chuỗi rỗng");
        }
    }

    private static void testPasswordStrengthValidation() {
        System.out.println("\n--- 2. Kiểm thử Validation độ mạnh mật khẩu ---");

        // Weak passwords
        assertCondition(!ValidationUtil.isStrongPassword("short1!"), "Từ chối mật khẩu quá ngắn (<8)");
        assertCondition(!ValidationUtil.isStrongPassword("toolongpasswordtoolongpasswordtoolongpasswordtoolong1!"), "Từ chối mật khẩu quá dài (>32)");
        assertCondition(!ValidationUtil.isStrongPassword("alllowercase1!"), "Từ chối mật khẩu thiếu chữ hoa");
        assertCondition(!ValidationUtil.isStrongPassword("NoDigitPassword!"), "Từ chối mật khẩu thiếu chữ số");
        assertCondition(!ValidationUtil.isStrongPassword("NoSpecial1234"), "Từ chối mật khẩu thiếu ký tự đặc biệt");

        // Strong password
        assertCondition(ValidationUtil.isStrongPassword("Courson@2026"), "Chấp nhận mật khẩu mạnh đầy đủ tiêu chí");
        assertCondition(ValidationUtil.isStrongPassword("Abcd@1234"), "Chấp nhận mật khẩu chuẩn hợp lệ");
    }

    private static void testTokenDaoOperations() {
        System.out.println("\n--- 3. Kiểm thử PasswordResetTokenDao với CSDL ---");

        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                // Find student user id
                Optional<User> studentOpt = userDao.findByEmail(con, "student@courson.edu.vn");
                if (!studentOpt.isPresent()) {
                    recordFailure("Không tìm thấy user student@courson.edu.vn để test");
                    return;
                }
                long userId = studentOpt.get().getId();

                // Clean existing tokens
                tokenDao.invalidateTokensByUserId(con, userId);

                // Insert token
                String rawToken = TokenUtil.generateToken();
                String tokenHash = TokenUtil.hashToken(rawToken);
                PasswordResetToken token = new PasswordResetToken(
                        null,
                        userId,
                        tokenHash,
                        OffsetDateTime.now().plusHours(24),
                        false,
                        OffsetDateTime.now()
                );
                long tokenId = tokenDao.insert(con, token);
                assertCondition(tokenId > 0, "Insert PasswordResetToken trả về id hợp lệ");

                // Query by hash
                Optional<PasswordResetToken> queriedOpt = tokenDao.findByTokenHash(con, tokenHash);
                assertCondition(queriedOpt.isPresent(), "Tìm thấy token bằng hash");
                assertCondition(queriedOpt.get().getUserId().equals(userId), "User ID của token khớp chính xác");
                assertCondition(!queriedOpt.get().isUsed(), "Token mới tạo có used = false");

                // Rate limiting
                boolean limited = tokenDao.isRateLimited(con, userId, 30);
                assertCondition(limited, "isRateLimited = true khi token vừa được tạo trong 30s");

                // Invalidate tokens
                tokenDao.invalidateTokensByUserId(con, userId);
                Optional<PasswordResetToken> invalidatedOpt = tokenDao.findByTokenHash(con, tokenHash);
                assertCondition(invalidatedOpt.isPresent() && invalidatedOpt.get().isUsed(),
                        "invalidateTokensByUserId cập nhật used = true");

                con.rollback(); // Rollback test changes
                recordPass("Dọn dẹp an toàn rollback dữ liệu test TokenDao");
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (Exception e) {
            recordFailure("Lỗi thao tác CSDL trong testTokenDaoOperations: " + e.getMessage());
        }
    }

    private static void testPasswordResetServiceFlow() {
        System.out.println("\n--- 4. Kiểm thử luồng PasswordResetService ---");

        // 4.1 Email validations
        try {
            resetService.sendResetRequest(null, "http://localhost:8080/Courson");
            recordFailure("sendResetRequest với email null phải ném exception");
        } catch (IllegalArgumentException | ValidationException e) {
            recordPass("sendResetRequest từ chối email null");
        }

        try {
            resetService.sendResetRequest("invalid-email-format", "http://localhost:8080/Courson");
            recordFailure("sendResetRequest với email sai format phải ném exception");
        } catch (IllegalArgumentException | ValidationException e) {
            recordPass("sendResetRequest từ chối email không hợp lệ");
        }

        try {
            resetService.sendResetRequest("nonexistent_user_9999@courson.edu.vn", "http://localhost:8080/Courson");
            recordFailure("sendResetRequest với email không tồn tại phải ném exception");
        } catch (IllegalArgumentException | ValidationException e) {
            recordPass("sendResetRequest báo lỗi tài khoản không tồn tại");
        }

        // 4.2 Valid email request & rate limiting
        try {
            // Đảm bảo test độc lập, dọn dẹp token gần nhất nếu test chạy liên tiếp < 30s
            try (Connection con = DbConnection.getConnection()) {
                Optional<User> studentOpt = userDao.findByEmail(con, "student@courson.edu.vn");
                if (studentOpt.isPresent()) {
                    tokenDao.invalidateTokensByUserId(con, studentOpt.get().getId());
                }
            }

            // First request succeeds
            resetService.sendResetRequest("student@courson.edu.vn", "http://localhost:8080/Courson");
            recordPass("sendResetRequest với student@courson.edu.vn thành công");

            // Immediate resend should trigger 30s rate limit
            try {
                resetService.resendResetRequest("student@courson.edu.vn", "http://localhost:8080/Courson");
                recordFailure("resendResetRequest trong 30s phải bị chặn rate limit");
            } catch (IllegalStateException e) {
                recordPass("resendResetRequest chặn chính xác theo rate limit 30s");
            }
        } catch (Exception e) {
            recordFailure("Lỗi kiểm thử gửi yêu cầu reset: " + e.getMessage());
        }
    }

    private static void testResetPasswordExecution() {
        System.out.println("\n--- 5. Kiểm thử đặt lại mật khẩu và cập nhật User ---");

        String testEmail = "student@courson.edu.vn";
        String rawToken = null;

        try (Connection con = DbConnection.getConnection()) {
            Optional<User> studentOpt = userDao.findByEmail(con, testEmail);
            if (!studentOpt.isPresent()) {
                recordFailure("Không tìm thấy student để test đặt lại mật khẩu");
                return;
            }
            long userId = studentOpt.get().getId();
            String originalPasswordHash = studentOpt.get().getPasswordHash();

            // Insert fresh valid token directly for controlled test
            rawToken = TokenUtil.generateToken();
            String tokenHash = TokenUtil.hashToken(rawToken);
            tokenDao.invalidateTokensByUserId(con, userId);
            PasswordResetToken token = new PasswordResetToken(
                    null,
                    userId,
                    tokenHash,
                    OffsetDateTime.now().plusHours(24),
                    false,
                    OffsetDateTime.now()
            );
            tokenDao.insert(con, token);

            // 5.1 Validate token
            User user = resetService.validateToken(rawToken);
            assertCondition(user != null && user.getId().equals(userId), "validateToken trả về đúng user");

            // 5.2 Validate invalid token
            try {
                resetService.validateToken("fake-random-token-xyz");
                recordFailure("validateToken với token giả mạo phải ném exception");
            } catch (IllegalArgumentException e) {
                recordPass("validateToken từ chối token không tồn tại");
            }

            // 5.3 Password mismatch
            try {
                resetService.resetPassword(rawToken, "Courson@2026", "Different@2026");
                recordFailure("resetPassword với mật khẩu không khớp phải ném exception");
            } catch (IllegalArgumentException | ValidationException e) {
                recordPass("resetPassword từ chối mật khẩu xác nhận không khớp");
            }

            // 5.4 Weak password
            try {
                resetService.resetPassword(rawToken, "weak", "weak");
                recordFailure("resetPassword với mật khẩu yếu phải ném exception");
            } catch (IllegalArgumentException | ValidationException e) {
                recordPass("resetPassword từ chối mật khẩu không đủ độ mạnh");
            }

            // 5.5 Successful reset
            String newPassword = "NewSecretPassword@2026";
            resetService.resetPassword(rawToken, newPassword, newPassword);
            recordPass("resetPassword thực thi thành công với mật khẩu hợp lệ");

            // 5.6 Verify token is now marked used
            try {
                resetService.validateToken(rawToken);
                recordFailure("validateToken trên token đã sử dụng phải ném exception");
            } catch (IllegalArgumentException e) {
                recordPass("Token đã sử dụng bị từ chối tái kích hoạt (Replay attack defense)");
            }

            // 5.7 Verify user password in DB has changed and works with PasswordUtil
            Optional<User> updatedUserOpt = userDao.findByEmail(con, testEmail);
            assertCondition(updatedUserOpt.isPresent(), "Tìm thấy user sau khi đổi mật khẩu");
            assertCondition(PasswordUtil.verify(newPassword, updatedUserOpt.get().getPasswordHash()),
                    "Mật khẩu mới đã được băm chuẩn BCrypt và xác thực khớp 100%");

            // Cleanup: restore standard seed password ("admin123") and clean tokens
            String defaultSeedHash = "$2a$12$Jl9I6uWRXBnYCHQmmh8o8eFWKFwQacRW3EWaTTLREbC6m8cWo2GTS";
            userDao.updatePassword(con, userId, defaultSeedHash);
            tokenDao.invalidateTokensByUserId(con, userId);
            recordPass("Dọn dẹp khôi phục mật khẩu gốc và vô hiệu hóa token thử nghiệm an toàn");

        } catch (Exception e) {
            recordFailure("Lỗi thực thi testResetPasswordExecution: " + e.getMessage());
        }
    }

    private static void recordPass(String message) {
        totalPassed++;
        System.out.println(" [PASS] " + message);
    }

    private static void recordFailure(String message) {
        totalFailed++;
        failures.add(message);
        System.out.println(" [FAIL] " + message);
    }

    private static void assertCondition(boolean condition, String message) {
        if (condition) {
            recordPass(message);
        } else {
            recordFailure(message);
        }
    }
}
