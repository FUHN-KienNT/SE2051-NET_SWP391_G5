package dao;

import entity.Module;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ModuleDao {
    private static final String SQL_FIND_BY_COURSE = "SELECT id, course_id, title, order_index, created_at FROM modules WHERE course_id = ? ORDER BY order_index ASC";
    private static final String SQL_FIND_BY_ID = "SELECT id, course_id, title, order_index, created_at FROM modules WHERE id = ?";
    private static final String SQL_EXISTS_ORDER = "SELECT COUNT(1) FROM modules WHERE course_id = ? AND order_index = ? AND (? IS NULL OR id != ?)";
    private static final String SQL_INSERT = "INSERT INTO modules (course_id, title, order_index, created_at) OUTPUT INSERTED.id VALUES (?, ?, ?, ?)";
    private static final String SQL_UPDATE = "UPDATE modules SET title = ?, order_index = ? WHERE id = ?";
    private static final String SQL_DELETE = "DELETE FROM modules WHERE id = ?";

    public List<Module> findByCourseId(Connection con, long courseId) throws SQLException {
        List<Module> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_COURSE)) {
            ps.setLong(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public Optional<Module> findById(Connection con, long id) throws SQLException {
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

    public boolean existsOrderIndex(Connection con, long courseId, int order, Long excludeId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_EXISTS_ORDER)) {
            ps.setLong(1, courseId);
            ps.setInt(2, order);
            if (excludeId == null) {
                ps.setNull(3, java.sql.Types.BIGINT);
                ps.setNull(4, java.sql.Types.BIGINT);
            } else {
                ps.setLong(3, excludeId);
                ps.setLong(4, excludeId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public long insert(Connection con, Module entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_INSERT)) {
            ps.setLong(1, entity.getCourseId());
            ps.setString(2, entity.getTitle());
            ps.setInt(3, entity.getOrderIndex());
            ps.setObject(4, entity.getCreatedAt() != null ? entity.getCreatedAt() : OffsetDateTime.now());
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

    public boolean update(Connection con, Module entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, entity.getTitle());
            ps.setInt(2, entity.getOrderIndex());
            ps.setLong(3, entity.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(Connection con, long id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_DELETE)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Module mapRow(ResultSet rs) throws SQLException {
        Module m = new Module();
        m.setId(rs.getLong("id"));
        m.setCourseId(rs.getLong("course_id"));
        m.setTitle(rs.getString("title"));
        m.setOrderIndex(rs.getInt("order_index"));
        m.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
        return m;
    }
}
