package dao;

import entity.VerificationToken;
import entity.enums.VerifyResult;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;

public class VerificationTokenDao {

    private static final String SQL_INSERT = 
        "INSERT INTO email_verification_tokens (user_id, token_hash, expires_at, used, created_at) " +
        "OUTPUT INSERTED.id VALUES (?, ?, ?, ?, ?)";

    private static final String SQL_INVALIDATE_BY_USER_ID = 
        "UPDATE email_verification_tokens SET used = 1 WHERE user_id = ? AND used = 0";

    private static final String SQL_GET_LATEST_TOKEN_TIME = 
        "SELECT TOP (1) created_at FROM email_verification_tokens WHERE user_id = ? ORDER BY id DESC";

    private static final String SQL_CONSUME_TOKEN = 
        "UPDATE email_verification_tokens SET used = 1 " +
        "OUTPUT INSERTED.user_id WHERE token_hash = ? AND used = 0 AND expires_at > SYSUTCDATETIME()";

    private static final String SQL_ACTIVATE_USER = 
        "UPDATE users SET status = 'ACTIVE', updated_at = SYSUTCDATETIME() WHERE id = ?";

    private static final String SQL_CHECK_TOKEN_STATUS = 
        "SELECT t.used, t.expires_at, u.status " +
        "FROM email_verification_tokens t " +
        "JOIN users u ON t.user_id = u.id " +
        "WHERE t.token_hash = ?";

    public long insert(Connection con, VerificationToken token) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_INSERT)) {
            ps.setLong(1, token.getUserId());
            ps.setString(2, token.getTokenHash());
            OffsetDateTime now = OffsetDateTime.now();
            ps.setObject(3, token.getExpiresAt() != null ? token.getExpiresAt() : now.plusHours(24));
            ps.setBoolean(4, token.isUsed());
            ps.setObject(5, token.getCreatedAt() != null ? token.getCreatedAt() : now);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    long id = rs.getLong(1);
                    token.setId(id);
                    return id;
                }
            }
        }
        return 0L;
    }

    public void invalidateTokensByUserId(Connection con, long userId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_INVALIDATE_BY_USER_ID)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
        }
    }

    public boolean isRateLimited(Connection con, long userId, int windowSeconds) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_GET_LATEST_TOKEN_TIME)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OffsetDateTime createdAt = rs.getObject("created_at", OffsetDateTime.class);
                    if (createdAt != null) {
                        return createdAt.plusSeconds(windowSeconds).isAfter(OffsetDateTime.now());
                    }
                }
            }
        }
        return false;
    }

    /**
     * Atomically consumes the verification token and activates the user.
     * Returns:
     * - SUCCESS if token was valid, unused, not expired, and user was activated.
     * - ALREADY_VERIFIED if token was already used but user is currently ACTIVE.
     * - INVALID_OR_EXPIRED if token does not exist, expired, or invalid.
     */
    public VerifyResult verifyAndConsume(Connection con, String tokenHash) throws SQLException {
        if (tokenHash == null || tokenHash.trim().isEmpty()) {
            return VerifyResult.INVALID_OR_EXPIRED;
        }

        Long userId = null;
        try (PreparedStatement ps = con.prepareStatement(SQL_CONSUME_TOKEN)) {
            ps.setString(1, tokenHash.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    userId = rs.getLong(1);
                }
            }
        }

        if (userId != null) {
            // Activate user
            try (PreparedStatement ps = con.prepareStatement(SQL_ACTIVATE_USER)) {
                ps.setLong(1, userId);
                ps.executeUpdate();
            }
            return VerifyResult.SUCCESS;
        }

        // Could not consume token: check if token was previously consumed and user is ACTIVE
        try (PreparedStatement ps = con.prepareStatement(SQL_CHECK_TOKEN_STATUS)) {
            ps.setString(1, tokenHash.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String userStatus = rs.getString("status");
                    if ("ACTIVE".equalsIgnoreCase(userStatus)) {
                        return VerifyResult.ALREADY_VERIFIED;
                    }
                }
            }
        }

        return VerifyResult.INVALID_OR_EXPIRED;
    }
}
