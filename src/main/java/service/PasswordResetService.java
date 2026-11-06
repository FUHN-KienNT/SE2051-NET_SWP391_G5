package service;

import dao.PasswordResetTokenDao;
import dao.UserDao;
import dao.VerificationTokenDao;
import entity.PasswordResetToken;
import entity.User;
import entity.enums.UserStatus;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DbConnection;
import util.MailUtil;
import util.PasswordUtil;
import util.TokenUtil;
import util.ValidationUtil;

public class PasswordResetService {

    private static final Logger LOGGER = Logger.getLogger(PasswordResetService.class.getName());
    private static final int RATE_LIMIT_SECONDS = 30;
    private static final int TOKEN_EXPIRY_HOURS = 24;

    private final UserDao userDao;
    private final PasswordResetTokenDao passwordResetTokenDao;

    public PasswordResetService() {
        this.userDao = new UserDao();
        this.passwordResetTokenDao = new PasswordResetTokenDao();
    }

    public PasswordResetService(UserDao userDao, PasswordResetTokenDao passwordResetTokenDao) {
        this.userDao = userDao;
        this.passwordResetTokenDao = passwordResetTokenDao;
    }

    /**
     * Handles forgot password request.
     * Throws ValidationException if email is missing/invalid or account does not exist.
     */
    public void sendResetRequest(String email, String dynamicBaseUrl) {
        createAndSendResetToken(email, dynamicBaseUrl, false);
    }

    /**
     * Resends password reset request with 30s rate limit protection.
     */
    public void resendResetRequest(String email, String dynamicBaseUrl) {
        createAndSendResetToken(email, dynamicBaseUrl, true);
    }

    private void createAndSendResetToken(String email, String dynamicBaseUrl, boolean isResend) {
        if (email == null || email.trim().isEmpty()) {
            if (isResend) {
                throw new IllegalArgumentException("Vui lòng cung cấp địa chỉ email.");
            }
            throw new ValidationException("email", "Vui lòng điền địa chỉ email của bạn.");
        }
        String cleanEmail = email.trim();
        if (!ValidationUtil.isEmail(cleanEmail)) {
            if (isResend) {
                throw new IllegalArgumentException("Định dạng email không hợp lệ.");
            }
            throw new ValidationException("email", "Email không đúng định dạng.");
        }

        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            User user;
            String rawToken;
            try {
                Optional<User> userOpt = userDao.findByEmail(con, cleanEmail);
                if (!userOpt.isPresent()) {
                    if (isResend) {
                        throw new IllegalArgumentException("Không tìm thấy tài khoản với email này.");
                    }
                    throw new ValidationException("email", "Không tìm thấy tài khoản với email này.");
                }
                user = userOpt.get();

                if (user.getStatus() == UserStatus.BANNED) {
                    throw new IllegalStateException("Tài khoản của bạn đã bị khóa.");
                }

                if (passwordResetTokenDao.isRateLimited(con, user.getId(), RATE_LIMIT_SECONDS)) {
                    throw new IllegalStateException("Vui lòng đợi 30 giây trước khi yêu cầu gửi lại email xác thực.");
                }

                rawToken = TokenUtil.generateToken();
                String tokenHash = TokenUtil.hashToken(rawToken);

                passwordResetTokenDao.invalidateTokensByUserId(con, user.getId());

                PasswordResetToken token = new PasswordResetToken(
                    null,
                    user.getId(),
                    tokenHash,
                    OffsetDateTime.now().plusHours(TOKEN_EXPIRY_HOURS),
                    false,
                    OffsetDateTime.now()
                );
                passwordResetTokenDao.insert(con, token);

                con.commit();
            } catch (SQLException e) {
                con.rollback();
                LOGGER.log(Level.SEVERE, "Lỗi cơ sở dữ liệu khi tạo yêu cầu đặt lại mật khẩu", e);
                throw new RuntimeException("Có lỗi xảy ra trên hệ thống, vui lòng thử lại sau.", e);
            } finally {
                con.setAutoCommit(true);
            }

            // Send email asynchronously AFTER transaction commit succeeds
            MailUtil.sendPasswordResetEmailAsync(user.getEmail(), user.getFullName(), rawToken, dynamicBaseUrl);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi kết nối cơ sở dữ liệu", e);
            throw new RuntimeException("Không thể kết nối đến cơ sở dữ liệu.", e);
        }
    }

    /**
     * Validates whether a reset token is valid and not used / expired.
     * Returns the corresponding User entity.
     */
    public User validateToken(String rawToken) {
        if (rawToken == null || rawToken.trim().isEmpty()) {
            throw new IllegalArgumentException("Liên kết đặt lại mật khẩu không hợp lệ.");
        }

        String tokenHash;
        try {
            tokenHash = TokenUtil.hashToken(rawToken.trim());
        } catch (Exception e) {
            throw new IllegalArgumentException("Liên kết đặt lại mật khẩu không hợp lệ.");
        }

        try (Connection con = DbConnection.getConnection()) {
            Optional<PasswordResetToken> tokenOpt = passwordResetTokenDao.findByTokenHash(con, tokenHash);
            if (!tokenOpt.isPresent()) {
                throw new IllegalArgumentException("Liên kết đặt lại mật khẩu không tồn tại hoặc không hợp lệ.");
            }

            PasswordResetToken token = tokenOpt.get();
            if (token.isUsed()) {
                throw new IllegalArgumentException("Liên kết đặt lại mật khẩu này đã được sử dụng. Vui lòng gửi lại yêu cầu mới nếu cần.");
            }

            if (token.getExpiresAt() != null && token.getExpiresAt().isBefore(OffsetDateTime.now())) {
                throw new IllegalArgumentException("Liên kết đặt lại mật khẩu đã hết hạn. Vui lòng gửi yêu cầu mới.");
            }

            Optional<User> userOpt = userDao.findById(con, token.getUserId());
            if (!userOpt.isPresent()) {
                throw new IllegalArgumentException("Không tìm thấy thông tin tài khoản liên kết với mã này.");
            }

            return userOpt.get();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi kiểm tra token đặt lại mật khẩu", e);
            throw new RuntimeException("Có lỗi hệ thống khi kiểm tra liên kết đặt lại mật khẩu.", e);
        }
    }

    /**
     * Executes password reset for valid token using atomic consume.
     */
    public void resetPassword(String rawToken, String newPassword, String confirmPassword) {
        if (rawToken == null || rawToken.trim().isEmpty()) {
            throw new IllegalArgumentException("Mã xác thực không hợp lệ.");
        }

        java.util.Map<String, String> errors = new java.util.LinkedHashMap<>();
        if (newPassword == null || newPassword.trim().isEmpty()) {
            errors.put("password", "Vui lòng nhập mật khẩu mới.");
        } else if (!ValidationUtil.isStrongPassword(newPassword)) {
            errors.put("password", "Mật khẩu phải từ 8–32 ký tự, gồm ít nhất 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.");
        }

        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errors.put("confirmPassword", "Vui lòng xác nhận mật khẩu mới.");
        } else if (newPassword != null && !newPassword.equals(confirmPassword)) {
            errors.put("confirmPassword", "Mật khẩu xác nhận không khớp.");
        }

        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }

        String tokenHash = TokenUtil.hashToken(rawToken.trim());

        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Optional<Long> consumedUserIdOpt = passwordResetTokenDao.verifyAndConsume(con, tokenHash);
                if (!consumedUserIdOpt.isPresent()) {
                    Optional<PasswordResetToken> tokenOpt = passwordResetTokenDao.findByTokenHash(con, tokenHash);
                    if (!tokenOpt.isPresent()) {
                        throw new IllegalArgumentException("Liên kết đặt lại mật khẩu không tồn tại hoặc không hợp lệ.");
                    }
                    PasswordResetToken token = tokenOpt.get();
                    if (token.isUsed()) {
                        throw new IllegalArgumentException("Liên kết đặt lại mật khẩu này đã được sử dụng.");
                    }
                    throw new IllegalArgumentException("Liên kết đặt lại mật khẩu đã hết hạn. Vui lòng gửi yêu cầu mới.");
                }

                long userId = consumedUserIdOpt.get();
                String passwordHash = PasswordUtil.hash(newPassword);

                boolean updated = userDao.updatePassword(con, userId, passwordHash);
                if (!updated) {
                    throw new RuntimeException("Cập nhật mật khẩu thất bại, không tìm thấy người dùng.");
                }

                // Kích hoạt tài khoản nếu đang ở trạng thái INACTIVE (đã xác thực qua email)
                Optional<User> userOpt = userDao.findById(con, userId);
                if (userOpt.isPresent() && userOpt.get().getStatus() == UserStatus.INACTIVE) {
                    userDao.updateStatus(con, userId, UserStatus.ACTIVE);
                    new VerificationTokenDao().invalidateTokensByUserId(con, userId);
                }

                con.commit();
            } catch (SQLException e) {
                con.rollback();
                LOGGER.log(Level.SEVERE, "Lỗi cơ sở dữ liệu khi đặt lại mật khẩu", e);
                throw new RuntimeException("Có lỗi xảy ra trên hệ thống khi cập nhật mật khẩu.", e);
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi kết nối cơ sở dữ liệu", e);
            throw new RuntimeException("Không thể kết nối đến cơ sở dữ liệu.", e);
        }
    }
}