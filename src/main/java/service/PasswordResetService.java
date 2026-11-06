package service;

import dao.PasswordResetTokenDao;
import dao.UserDao;
import entity.PasswordResetToken;
import entity.User;
import entity.enums.UserStatus;
import dao.VerificationTokenDao;
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
     * Throws IllegalArgumentException if email not provided or if account does not exist.
     */
    public void sendResetRequest(String email, String dynamicBaseUrl) {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng điền địa chỉ email của bạn.");
        }
        String cleanEmail = email.trim();
        if (!ValidationUtil.isEmail(cleanEmail)) {
            throw new IllegalArgumentException("Định dạng email không hợp lệ.");
        }

        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Optional<User> userOpt = userDao.findByEmail(con, cleanEmail);
                if (!userOpt.isPresent()) {
                    throw new IllegalArgumentException("Không tìm thấy tài khoản với email này.");
                }
                User user = userOpt.get();

                if (user.getStatus() == UserStatus.BANNED) {
                    throw new IllegalStateException("Tài khoản của bạn đã bị khóa.");
                }

                if (passwordResetTokenDao.isRateLimited(con, user.getId(), 30)) {
                    throw new IllegalStateException("Vui lòng đợi 30 giây trước khi yêu cầu gửi lại email xác thực.");
                }

                // Generate secure token
                String rawToken = TokenUtil.generateToken();
                String tokenHash = TokenUtil.hashToken(rawToken);

                // Invalidate previous tokens
                passwordResetTokenDao.invalidateTokensByUserId(con, user.getId());

                // Insert new reset token valid for 24 hours
                PasswordResetToken token = new PasswordResetToken(
                    null,
                    user.getId(),
                    tokenHash,
                    OffsetDateTime.now().plusHours(24),
                    false,
                    OffsetDateTime.now()
                );
                passwordResetTokenDao.insert(con, token);

                con.commit();

                // Send email asynchronously
                MailUtil.sendPasswordResetEmailAsync(user.getEmail(), user.getFullName(), rawToken, dynamicBaseUrl);
            } catch (SQLException e) {
                con.rollback();
                LOGGER.log(Level.SEVERE, "Lỗi cơ sở dữ liệu khi tạo yêu cầu đặt lại mật khẩu", e);
                throw new RuntimeException("Có lỗi xảy ra trên hệ thống, vui lòng thử lại sau.", e);
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi kết nối cơ sở dữ liệu", e);
            throw new RuntimeException("Không thể kết nối đến cơ sở dữ liệu.", e);
        }
    }

    /**
     * Resends password reset request with 30s rate limit protection.
     */
    public void resendResetRequest(String email, String dynamicBaseUrl) {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng cung cấp địa chỉ email.");
        }
        String cleanEmail = email.trim();
        if (!ValidationUtil.isEmail(cleanEmail)) {
            throw new IllegalArgumentException("Định dạng email không hợp lệ.");
        }

        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Optional<User> userOpt = userDao.findByEmail(con, cleanEmail);
                if (!userOpt.isPresent()) {
                    throw new IllegalArgumentException("Không tìm thấy tài khoản với email này.");
                }
                User user = userOpt.get();

                if (user.getStatus() == UserStatus.BANNED) {
                    throw new IllegalStateException("Tài khoản của bạn đã bị khóa.");
                }

                if (passwordResetTokenDao.isRateLimited(con, user.getId(), 30)) {
                    throw new IllegalStateException("Vui lòng đợi 30 giây trước khi yêu cầu gửi lại email xác thực.");
                }

                // Rate limiting check (30 seconds)
                if (passwordResetTokenDao.isRateLimited(con, user.getId(), 30)) {
                    throw new IllegalStateException("Vui lòng đợi 30 giây trước khi yêu cầu gửi lại email xác thực.");
                }

                // Generate new secure token
                String rawToken = TokenUtil.generateToken();
                String tokenHash = TokenUtil.hashToken(rawToken);

                // Invalidate old tokens
                passwordResetTokenDao.invalidateTokensByUserId(con, user.getId());

                // Insert new reset token valid for 24 hours
                PasswordResetToken token = new PasswordResetToken(
                    null,
                    user.getId(),
                    tokenHash,
                    OffsetDateTime.now().plusHours(24),
                    false,
                    OffsetDateTime.now()
                );
                passwordResetTokenDao.insert(con, token);

                con.commit();

                // Send email asynchronously
                MailUtil.sendPasswordResetEmailAsync(user.getEmail(), user.getFullName(), rawToken, dynamicBaseUrl);
            } catch (SQLException e) {
                con.rollback();
                LOGGER.log(Level.SEVERE, "Lỗi cơ sở dữ liệu khi gửi lại email đặt lại mật khẩu", e);
                throw new RuntimeException("Có lỗi xảy ra trên hệ thống, vui lòng thử lại sau.", e);
            } finally {
                con.setAutoCommit(true);
            }
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
     * Executes password reset for valid token.
     */
    public void resetPassword(String rawToken, String newPassword, String confirmPassword) {
        if (rawToken == null || rawToken.trim().isEmpty()) {
            throw new IllegalArgumentException("Mã xác thực không hợp lệ.");
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập mật khẩu mới.");
        }

        if (!ValidationUtil.isStrongPassword(newPassword)) {
            throw new IllegalArgumentException("Mật khẩu phải từ 8–32 ký tự, gồm ít nhất 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.");
        }

        if (confirmPassword == null || !newPassword.equals(confirmPassword)) {
            throw new IllegalArgumentException("Mật khẩu xác nhận không khớp.");
        }

        String tokenHash = TokenUtil.hashToken(rawToken.trim());

        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Optional<PasswordResetToken> tokenOpt = passwordResetTokenDao.findByTokenHash(con, tokenHash);
                if (!tokenOpt.isPresent()) {
                    throw new IllegalArgumentException("Liên kết đặt lại mật khẩu không tồn tại hoặc không hợp lệ.");
                }

                PasswordResetToken token = tokenOpt.get();
                if (token.isUsed()) {
                    throw new IllegalArgumentException("Liên kết đặt lại mật khẩu này đã được sử dụng.");
                }

                if (token.getExpiresAt() != null && token.getExpiresAt().isBefore(OffsetDateTime.now())) {
                    throw new IllegalArgumentException("Liên kết đặt lại mật khẩu đã hết hạn. Vui lòng gửi yêu cầu mới.");
                }

                String passwordHash = PasswordUtil.hash(newPassword);

                boolean updated = userDao.updatePassword(con, token.getUserId(), passwordHash);
                if (!updated) {
                    throw new RuntimeException("Cập nhật mật khẩu thất bại, không tìm thấy người dùng.");
                }

                // Kích hoạt tài khoản nếu đang ở trạng thái INACTIVE (đã xác thực qua email)
                Optional<User> userOpt = userDao.findById(con, token.getUserId());
                if (userOpt.isPresent() && userOpt.get().getStatus() == UserStatus.INACTIVE) {
                    userDao.updateStatus(con, token.getUserId(), UserStatus.ACTIVE);
                    new VerificationTokenDao().invalidateTokensByUserId(con, token.getUserId());
                }

                passwordResetTokenDao.markAsUsed(con, token.getId());

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
