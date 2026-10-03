package service;

import dao.UserDao;
import dao.VerificationTokenDao;
import entity.User;
import entity.VerificationToken;
import entity.enums.UserStatus;
import entity.enums.VerifyResult;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DbConnection;
import util.MailUtil;
import util.TokenUtil;

public class EmailVerificationService {

    private static final Logger LOGGER = Logger.getLogger(EmailVerificationService.class.getName());
    private static final int RESEND_RATE_LIMIT_SECONDS = 60;
    private static final int TOKEN_EXPIRY_HOURS = 24;

    private final VerificationTokenDao verificationTokenDao;
    private final UserDao userDao;

    public EmailVerificationService(VerificationTokenDao verificationTokenDao, UserDao userDao) {
        this.verificationTokenDao = verificationTokenDao;
        this.userDao = userDao;
    }

    /**
     * Generates a new verification token, saves the SHA-256 hash in DB, and dispatches the email asynchronously.
     * Can be invoked within an existing transaction.
     */
    public void createAndSendToken(Connection con, User user, String dynamicBaseUrl) throws SQLException {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("User và User ID không được để trống khi sinh token");
        }

        // Invalidate any existing unused tokens for this user
        verificationTokenDao.invalidateTokensByUserId(con, user.getId());

        // Generate cryptographically secure token
        String rawToken = TokenUtil.generateToken();
        String tokenHash = TokenUtil.hashToken(rawToken);

        VerificationToken token = new VerificationToken();
        token.setUserId(user.getId());
        token.setTokenHash(tokenHash);
        token.setExpiresAt(OffsetDateTime.now().plusHours(TOKEN_EXPIRY_HOURS));
        token.setUsed(false);
        token.setCreatedAt(OffsetDateTime.now());

        verificationTokenDao.insert(con, token);

        // Dispatch email asynchronously
        MailUtil.sendVerificationEmailAsync(user.getEmail(), user.getFullName(), rawToken, dynamicBaseUrl);
    }

    /**
     * Verifies the email token with SHA-256 hash lookup.
     * Returns: SUCCESS, ALREADY_VERIFIED, or INVALID_OR_EXPIRED.
     */
    public VerifyResult verifyEmail(String rawToken) {
        if (rawToken == null || rawToken.trim().isEmpty()) {
            return VerifyResult.INVALID_OR_EXPIRED;
        }

        String tokenHash;
        try {
            tokenHash = TokenUtil.hashToken(rawToken.trim());
        } catch (Exception e) {
            return VerifyResult.INVALID_OR_EXPIRED;
        }

        try (Connection con = DbConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                VerifyResult result = verificationTokenDao.verifyAndConsume(con, tokenHash);
                con.commit();
                return result;
            } catch (Exception e) {
                DbConnection.rollbackQuietly(con);
                LOGGER.log(Level.SEVERE, "Lỗi khi kích hoạt token xác thực email", e);
                return VerifyResult.INVALID_OR_EXPIRED;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi kết nối CSDL khi xác thực email", e);
            return VerifyResult.INVALID_OR_EXPIRED;
        }
    }

    /**
     * Handles resending verification email.
     * Throws IllegalStateException if rate limit (60s) is violated.
     * For non-existent or already active users, completes silently without leaking user existence.
     */
    public void resendVerification(String emailOrUsername, String dynamicBaseUrl) {
        if (emailOrUsername == null || emailOrUsername.trim().isEmpty()) {
            return;
        }

        try (Connection con = DbConnection.getConnection()) {
            Optional<User> userOpt = userDao.findByUsernameOrEmail(con, emailOrUsername.trim());
            if (!userOpt.isPresent()) {
                // Do not reveal that account does not exist
                return;
            }

            User user = userOpt.get();
            if (user.getStatus() != UserStatus.INACTIVE) {
                // Already active or banned; do not send verification link
                return;
            }

            // Check rate limiting (1 email per 60 seconds)
            if (verificationTokenDao.isRateLimited(con, user.getId(), RESEND_RATE_LIMIT_SECONDS)) {
                throw new IllegalStateException("Vui lòng đợi 60 giây trước khi yêu cầu gửi lại email xác nhận.");
            }

            con.setAutoCommit(false);
            try {
                createAndSendToken(con, user, dynamicBaseUrl);
                con.commit();
            } catch (Exception ex) {
                DbConnection.rollbackQuietly(con);
                LOGGER.log(Level.SEVERE, "Lỗi khi tạo lại token xác nhận cho user: " + user.getId(), ex);
                throw new RuntimeException("Có lỗi xảy ra khi tạo mã xác nhận mới.", ex);
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi CSDL khi gửi lại email xác nhận", e);
            throw new RuntimeException("Lỗi hệ thống khi gửi lại email xác nhận.", e);
        }
    }
}
