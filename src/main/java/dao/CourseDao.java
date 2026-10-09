package dao;

import entity.Course;
import entity.enums.CourseStatus;
import entity.enums.SettingType;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CourseDao {
    private static final String SQL_FIND_ALL = "SELECT id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at FROM courses ORDER BY id DESC";
    private static final String SQL_FIND_BY_ID = "SELECT id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at FROM courses WHERE id = ?";
    private static final String SQL_FIND_BY_MANAGER_OR_EXPERT = "SELECT id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at FROM courses WHERE manager_id = ? OR expert_id = ? ORDER BY id DESC";
    private static final String SQL_INSERT = "INSERT INTO courses (title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at) OUTPUT INSERTED.id VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SQL_UPDATE = "UPDATE courses SET title = ?, category_id = ?, category_type = ?, description = ?, price = ?, status = ?, manager_id = ?, expert_id = ?, updated_at = ? WHERE id = ?";
    private static final String SQL_DELETE = "DELETE FROM courses WHERE id = ?";

    public List<Course> findAll(Connection con) throws SQLException {
        List<Course> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<Course> searchPublished(Connection con, String keyword, Long categoryId) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at FROM courses WHERE status = 'PUBLISHED'");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(title) LIKE ? OR LOWER(description) LIKE ?)");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (categoryId != null) {
            sql.append(" AND category_id = ?");
            params.add(categoryId);
        }
        sql.append(" ORDER BY id DESC");

        List<Course> list = new ArrayList<>();
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

    public List<Course> searchAdmin(Connection con, String keyword, Long categoryId, Long managerId, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at FROM courses WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(title) LIKE ? OR CAST(id AS TEXT) = ?)");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(keyword.trim());
        }
        if (categoryId != null) {
            sql.append(" AND category_id = ?");
            params.add(categoryId);
        }
        if (managerId != null) {
            sql.append(" AND manager_id = ?");
            params.add(managerId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status.trim());
        }
        sql.append(" ORDER BY id DESC");

        List<Course> list = new ArrayList<>();
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

    public Optional<Course> findById(Connection con, long id) throws SQLException {
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

    public List<Course> findByManagerOrExpert(Connection con, long userId) throws SQLException {
        List<Course> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_MANAGER_OR_EXPERT)) {
            ps.setLong(1, userId);
            ps.setLong(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public long insert(Connection con, Course entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_INSERT)) {
            ps.setString(1, entity.getTitle());
            if (entity.getCategoryId() != null) ps.setLong(2, entity.getCategoryId());
            else ps.setNull(2, java.sql.Types.BIGINT);
            ps.setString(3, entity.getCategoryType() != null ? entity.getCategoryType().getDbValue() : SettingType.COURSE_CATEGORY.getDbValue());
            ps.setString(4, entity.getDescription());
            ps.setBigDecimal(5, entity.getPrice() != null ? entity.getPrice() : BigDecimal.ZERO);
            ps.setString(6, entity.getStatus() != null ? entity.getStatus().getDbValue() : CourseStatus.DRAFT.getDbValue());
            if (entity.getManagerId() != null) ps.setLong(7, entity.getManagerId());
            else ps.setNull(7, java.sql.Types.BIGINT);
            if (entity.getExpertId() != null) ps.setLong(8, entity.getExpertId());
            else ps.setNull(8, java.sql.Types.BIGINT);
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

    public boolean update(Connection con, Course entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, entity.getTitle());
            if (entity.getCategoryId() != null) ps.setLong(2, entity.getCategoryId());
            else ps.setNull(2, java.sql.Types.BIGINT);
            ps.setString(3, entity.getCategoryType() != null ? entity.getCategoryType().getDbValue() : SettingType.COURSE_CATEGORY.getDbValue());
            ps.setString(4, entity.getDescription());
            ps.setBigDecimal(5, entity.getPrice() != null ? entity.getPrice() : BigDecimal.ZERO);
            ps.setString(6, entity.getStatus() != null ? entity.getStatus().getDbValue() : CourseStatus.DRAFT.getDbValue());
            if (entity.getManagerId() != null) ps.setLong(7, entity.getManagerId());
            else ps.setNull(7, java.sql.Types.BIGINT);
            if (entity.getExpertId() != null) ps.setLong(8, entity.getExpertId());
            else ps.setNull(8, java.sql.Types.BIGINT);
            ps.setObject(9, OffsetDateTime.now());
            ps.setLong(10, entity.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(Connection con, long id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_DELETE)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Course mapRow(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setId(rs.getLong("id"));
        c.setTitle(rs.getString("title"));
        long catId = rs.getLong("category_id");
        c.setCategoryId(rs.wasNull() ? null : catId);
        c.setCategoryType(SettingType.fromDb(rs.getString("category_type")));
        c.setDescription(rs.getString("description"));
        c.setPrice(rs.getBigDecimal("price"));
        c.setStatus(CourseStatus.fromDb(rs.getString("status")));
        long mId = rs.getLong("manager_id");
        c.setManagerId(rs.wasNull() ? null : mId);
        long eId = rs.getLong("expert_id");
        c.setExpertId(rs.wasNull() ? null : eId);
        c.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
        c.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
        return c;
    }
}
