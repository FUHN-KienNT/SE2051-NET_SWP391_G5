package dao;

import entity.PasswordResetToken;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.Optional;

public class PasswordResetTokenDao {

    private static final String SQL_INSERT =
        "INSERT INTO password_reset_tokens (user_id, token_hash, expires_at, used, created_at) " +
        "VALUES (?, ?, ?, ?, ?) RETURNING id";

    private static final String SQL_INVALIDATE_BY_USER_ID =
        "UPDATE password_reset_tokens SET used = TRUE WHERE user_id = ? AND used = FALSE";

    private static final String SQL_FIND_BY_TOKEN_HASH =
        "SELECT id, user_id, token_hash, expires_at, used, created_at " +
        "FROM password_reset_tokens WHERE token_hash = ?";

    private static final String SQL_MARK_AS_USED =
        "UPDATE password_reset_tokens SET used = TRUE WHERE id = ?";

    private static final String SQL_CONSUME_TOKEN =
        "UPDATE password_reset_tokens SET used = TRUE WHERE token_hash = ? AND used = FALSE AND expires_at > NOW() RETURNING user_id";

    private static final String SQL_GET_LATEST_TOKEN_TIME =
        "SELECT created_at FROM password_reset_tokens WHERE user_id = ? ORDER BY id DESC LIMIT 1";

    public long insert(Connection con, PasswordResetToken token) throws SQLException {
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

    public Optional<PasswordResetToken> findByTokenHash(Connection con, String tokenHash) throws SQLException {
        if (tokenHash == null || tokenHash.trim().isEmpty()) {
            return Optional.empty();
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_TOKEN_HASH)) {
            ps.setString(1, tokenHash.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        }
        return Optional.empty();
    }

    public boolean markAsUsed(Connection con, long tokenId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_MARK_AS_USED)) {
            ps.setLong(1, tokenId);
            return ps.executeUpdate() > 0;
        }
    }

    public Optional<Long> verifyAndConsume(Connection con, String tokenHash) throws SQLException {
        if (tokenHash == null || tokenHash.trim().isEmpty()) {
            return Optional.empty();
        }
        try (PreparedStatement ps = con.prepareStatement(SQL_CONSUME_TOKEN)) {
            ps.setString(1, tokenHash.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(rs.getLong(1));
                }
            }
        }
        return Optional.empty();
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

    private PasswordResetToken mapRow(ResultSet rs) throws SQLException {
        PasswordResetToken token = new PasswordResetToken();
        token.setId(rs.getLong("id"));
        token.setUserId(rs.getLong("user_id"));
        token.setTokenHash(rs.getString("token_hash"));
        token.setExpiresAt(rs.getObject("expires_at", OffsetDateTime.class));
        token.setUsed(rs.getBoolean("used"));
        token.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
        return token;
    }
}
