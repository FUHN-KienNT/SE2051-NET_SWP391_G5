package dao;

import entity.User;
import entity.enums.AuthProvider;
import entity.enums.SettingType;
import entity.enums.UserStatus;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UserDao {
    private static final String SQL_FIND_ALL = "SELECT id, username, email, password_hash, full_name, role_id, role_type, auth_provider, status, created_at, updated_at, avatar_url, phone, birth_date, bio FROM users ORDER BY id DESC";
    private static final String SQL_FIND_BY_ID = "SELECT id, username, email, password_hash, full_name, role_id, role_type, auth_provider, status, created_at, updated_at, avatar_url, phone, birth_date, bio FROM users WHERE id = ?";
    private static final String SQL_FIND_BY_EMAIL = "SELECT id, username, email, password_hash, full_name, role_id, role_type, auth_provider, status, created_at, updated_at, avatar_url, phone, birth_date, bio FROM users WHERE LOWER(email) = LOWER(?)";
    private static final String SQL_FIND_BY_USERNAME_OR_EMAIL = "SELECT id, username, email, password_hash, full_name, role_id, role_type, auth_provider, status, created_at, updated_at, avatar_url, phone, birth_date, bio FROM users WHERE LOWER(username) = LOWER(?) OR LOWER(email) = LOWER(?)";
    private static final String SQL_EXISTS_USERNAME = "SELECT COUNT(1) FROM users WHERE LOWER(username) = LOWER(?) AND (? IS NULL OR id != ?)";
    private static final String SQL_EXISTS_EMAIL = "SELECT COUNT(1) FROM users WHERE LOWER(email) = LOWER(?) AND (? IS NULL OR id != ?)";
    private static final String SQL_INSERT = "INSERT INTO users (username, email, password_hash, full_name, role_id, role_type, auth_provider, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING id";
    private static final String SQL_UPDATE = "UPDATE users SET full_name = ?, role_id = ?, role_type = ?, status = ?, password_hash = COALESCE(?, password_hash), phone = COALESCE(?, phone), updated_at = ? WHERE id = ?";
    private static final String SQL_UPDATE_STATUS = "UPDATE users SET status = ?, updated_at = ? WHERE id = ?";

    /**
     * Truy vấn toàn bộ danh sách người dùng trong bảng 'users'.
     */
    public List<User> findAll(Connection con) throws SQLException {
        List<User> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    /**
     * Tìm kiếm, lọc và sắp xếp người dùng cho màn hình Admin User List (SRS 2.3.1).
     */
    public List<User> search(Connection con, Long roleId, String status, String keyword, String sortBy, String sortOrder) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT id, username, email, password_hash, full_name, role_id, role_type, auth_provider, status, created_at, updated_at, avatar_url, phone, birth_date, bio FROM users WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (roleId != null && roleId > 0) {
            sql.append(" AND role_id = ?");
            params.add(roleId);
        }

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status.trim())) {
            String norm = status.trim().toUpperCase();
            if ("SUSPENDED".equals(norm) || "BANNED".equals(norm)) {
                sql.append(" AND status = 'BANNED'");
            } else if ("ACTIVE".equals(norm)) {
                sql.append(" AND status = 'ACTIVE'");
            } else if ("INACTIVE".equals(norm)) {
                sql.append(" AND status = 'INACTIVE'");
            } else {
                sql.append(" AND status = ?");
                params.add(norm);
            }
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            sql.append(" AND (LOWER(full_name) LIKE ? OR LOWER(username) LIKE ? OR LOWER(email) LIKE ?)");
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        String orderCol = "id";
        String dir = "DESC";

        if (sortBy != null && !sortBy.trim().isEmpty()) {
            switch (sortBy.trim().toLowerCase()) {
                case "id":
                    orderCol = "id";
                    break;
                case "name":
                case "fullname":
                    orderCol = "full_name";
                    break;
                case "username":
                    orderCol = "username";
                    break;
                case "email":
                    orderCol = "email";
                    break;
                case "role":
                    orderCol = "role_id";
                    break;
                case "status":
                    orderCol = "status";
                    break;
                case "created":
                case "createddate":
                case "created_at":
                    orderCol = "created_at";
                    break;
                default:
                    orderCol = "id";
                    break;
            }
        }

        if ("asc".equalsIgnoreCase(sortOrder)) {
            dir = "ASC";
        } else if ("desc".equalsIgnoreCase(sortOrder)) {
            dir = "DESC";
        }

        sql.append(" ORDER BY ").append(orderCol).append(" ").append(dir);

        List<User> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    /**
     * Tìm kiếm người dùng theo ID trong bảng 'users'.
     */
    public Optional<User> findById(Connection con, long id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_ID)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        }
        return Optional.empty();
    }

    public List<User> findByRoleId(Connection con, long roleId) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, username, email, password_hash, full_name, role_id, role_type, auth_provider, status, created_at, updated_at, avatar_url, phone, birth_date, bio FROM users WHERE role_id = ? ORDER BY full_name ASC";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public Optional<User> findByUsernameOrEmail(Connection con, String value) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_USERNAME_OR_EMAIL)) {
            ps.setString(1, value);
            ps.setString(2, value);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        }
        return Optional.empty();
    }

    /**
     * Tìm user theo email chính xác (case-insensitive).
     * Dùng cho Google OAuth — tránh nhầm với username trùng.
     */
    public Optional<User> findByEmail(Connection con, String email) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_EMAIL)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        }
        return Optional.empty();
    }

    /**
     * Tìm ID của Manager đang ACTIVE khả dụng nhất để phân công cho khóa học mới.
     */
    public Optional<Long> findDefaultManagerId(Connection con) throws SQLException {
        String sqlManager = "SELECT u.id FROM users u " +
                            "JOIN settings s ON u.role_id = s.id AND u.role_type = s.type " +
                            "LEFT JOIN courses c ON c.manager_id = u.id " +
                            "WHERE s.type = 'USER_ROLE' AND UPPER(s.value) = 'MANAGER' AND u.status = 'ACTIVE' " +
                            "GROUP BY u.id " +
                            "ORDER BY COUNT(c.id) ASC, u.id ASC LIMIT 1";
        try (PreparedStatement ps = con.prepareStatement(sqlManager);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return Optional.of(rs.getLong("id"));
            }
        }

        String sqlAdmin = "SELECT u.id FROM users u " +
                          "JOIN settings s ON u.role_id = s.id AND u.role_type = s.type " +
                          "WHERE s.type = 'USER_ROLE' AND UPPER(s.value) = 'ADMIN' AND u.status = 'ACTIVE' " +
                          "ORDER BY u.id ASC LIMIT 1";
        try (PreparedStatement ps = con.prepareStatement(sqlAdmin);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return Optional.of(rs.getLong("id"));
            }
        }

        String sqlAny = "SELECT id FROM users WHERE status = 'ACTIVE' ORDER BY id ASC LIMIT 1";
        try (PreparedStatement ps = con.prepareStatement(sqlAny);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return Optional.of(rs.getLong("id"));
            }
        }

        return Optional.empty();
    }

    public boolean existsUsername(Connection con, String username, Long excludeId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_EXISTS_USERNAME)) {
            ps.setString(1, username);
            if (excludeId == null) {
                ps.setNull(2, java.sql.Types.BIGINT);
                ps.setNull(3, java.sql.Types.BIGINT);
            } else {
                ps.setLong(2, excludeId);
                ps.setLong(3, excludeId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean existsEmail(Connection con, String email, Long excludeId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_EXISTS_EMAIL)) {
            ps.setString(1, email);
            if (excludeId == null) {
                ps.setNull(2, java.sql.Types.BIGINT);
                ps.setNull(3, java.sql.Types.BIGINT);
            } else {
                ps.setLong(2, excludeId);
                ps.setLong(3, excludeId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Thêm mới một tài khoản người dùng vào bảng 'users'.
     */
    public long insert(Connection con, User entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_INSERT)) {
            ps.setString(1, entity.getUsername());
            ps.setString(2, entity.getEmail());
            ps.setString(3, entity.getPasswordHash());
            ps.setString(4, entity.getFullName());
            if (entity.getRoleId() != null) ps.setLong(5, entity.getRoleId());
            else ps.setNull(5, java.sql.Types.BIGINT);
            ps.setString(6, entity.getRoleType() != null ? entity.getRoleType().getDbValue() : SettingType.USER_ROLE.getDbValue());
            ps.setString(7, entity.getAuthProvider() != null ? entity.getAuthProvider().getDbValue() : AuthProvider.LOCAL.getDbValue());
            ps.setString(8, entity.getStatus() != null ? entity.getStatus().getDbValue() : UserStatus.ACTIVE.getDbValue());
            OffsetDateTime now = OffsetDateTime.now();
            ps.setObject(9, entity.getCreatedAt() != null ? entity.getCreatedAt() : now);
            ps.setObject(10, entity.getUpdatedAt() != null ? entity.getUpdatedAt() : now);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    long id = rs.getLong(1);
                    entity.setId(id);
                    return id;
                }
            }
        }
        return 0L;
    }

    /**
     * Cập nhật thông tin và vai trò (role_id) của người dùng trong bảng 'users'.
     */
    public boolean update(Connection con, User entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, entity.getFullName());
            if (entity.getRoleId() != null) ps.setLong(2, entity.getRoleId());
            else ps.setNull(2, java.sql.Types.BIGINT);
            ps.setString(3, entity.getRoleType() != null ? entity.getRoleType().getDbValue() : SettingType.USER_ROLE.getDbValue());
            ps.setString(4, entity.getStatus() != null ? entity.getStatus().getDbValue() : UserStatus.ACTIVE.getDbValue());
            ps.setString(5, entity.getPasswordHash());
            ps.setString(6, entity.getPhone());
            ps.setObject(7, OffsetDateTime.now());
            ps.setLong(8, entity.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(Connection con, long id, String passwordHash) throws SQLException {
        String sql = "UPDATE users SET password_hash = ?, updated_at = ? WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, passwordHash);
            ps.setObject(2, OffsetDateTime.now());
            ps.setLong(3, id);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật trạng thái tài khoản (ACTIVE / BANNED) trong bảng 'users'.
     */
    public boolean updateStatus(Connection con, long id, UserStatus status) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE_STATUS)) {
            ps.setString(1, status.getDbValue());
            ps.setObject(2, OffsetDateTime.now());
            ps.setLong(3, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateAuthProvider(Connection con, long id, AuthProvider authProvider) throws SQLException {
        String sql = "UPDATE users SET auth_provider = ?, updated_at = ? WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, authProvider.getDbValue());
            ps.setObject(2, OffsetDateTime.now());
            ps.setLong(3, id);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Đếm số lượng khóa học người dùng đã đăng ký (Bảng registrations).
     */
    public int countUserRegistrations(Connection con, long userId) throws SQLException {
        String sql = "SELECT COUNT(1) FROM registrations WHERE user_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Đếm số lượng khóa học Chuyên gia đang được phân công phụ trách (Bảng courses).
     */
    public int countExpertCourses(Connection con, long userId) throws SQLException {
        String sql = "SELECT COUNT(1) FROM courses WHERE expert_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Đếm số lượng khóa học Quản lý đang phụ trách (Bảng courses).
     */
    public int countManagerCourses(Connection con, long userId) throws SQLException {
        String sql = "SELECT COUNT(1) FROM courses WHERE manager_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Đếm số lượng Quản trị viên (Admin - role_id = 5) đang hoạt động (ACTIVE).
     */
    public int countActiveAdmins(Connection con) throws SQLException {
        String sql = "SELECT COUNT(1) FROM users WHERE role_id = 5 AND status = 'ACTIVE'";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    /**
     * Xóa tài khoản người dùng khỏi bảng 'users'.
     */
    public boolean delete(Connection con, long id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getLong("id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFullName(rs.getString("full_name"));
        long roleId = rs.getLong("role_id");
        u.setRoleId(rs.wasNull() ? null : roleId);
        u.setRoleType(SettingType.fromDb(rs.getString("role_type")));
        u.setAuthProvider(AuthProvider.fromDb(rs.getString("auth_provider")));
        u.setStatus(UserStatus.fromDb(rs.getString("status")));
        u.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
        u.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
        u.setAvatarUrl(rs.getString("avatar_url"));
        u.setPhone(rs.getString("phone"));
        java.sql.Date bd = rs.getDate("birth_date");
        u.setBirthDate(bd != null ? bd.toLocalDate() : null);
        u.setBio(rs.getString("bio"));
        return u;
    }
}
