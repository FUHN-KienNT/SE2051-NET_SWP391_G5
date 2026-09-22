package dao;

import entity.Setting;
import entity.enums.SettingStatus;
import entity.enums.SettingType;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class SettingDao {
    private static final String SQL_FIND_BY_TYPE = "SELECT id, type, name, value, priority, status, description, created_at, updated_at FROM settings WHERE type = ? ORDER BY priority ASC, name ASC";
    private static final String SQL_FIND_BY_ID = "SELECT id, type, name, value, priority, status, description, created_at, updated_at FROM settings WHERE id = ?";
    private static final String SQL_INSERT = "INSERT INTO settings (type, name, value, priority, status, description, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?) RETURNING id";
    private static final String SQL_UPDATE = "UPDATE settings SET type = ?, name = ?, value = ?, priority = ?, status = ?, description = ?, updated_at = ? WHERE id = ?";
    private static final String SQL_DELETE = "DELETE FROM settings WHERE id = ?";

    public List<Setting> findByType(Connection con, SettingType type) throws SQLException {
        List<Setting> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_TYPE)) {
            ps.setString(1, type.getDbValue());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public Optional<Setting> findById(Connection con, long id) throws SQLException {
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

    public long insert(Connection con, Setting entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_INSERT)) {
            ps.setString(1, entity.getType().getDbValue());
            ps.setString(2, entity.getName());
            ps.setString(3, entity.getValue());
            ps.setInt(4, entity.getPriority());
            ps.setString(5, entity.getStatus().getDbValue());
            ps.setString(6, entity.getDescription());
            OffsetDateTime now = OffsetDateTime.now();
            ps.setObject(7, entity.getCreatedAt() != null ? entity.getCreatedAt() : now);
            ps.setObject(8, entity.getUpdatedAt() != null ? entity.getUpdatedAt() : now);
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

    public boolean update(Connection con, Setting entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, entity.getType().getDbValue());
            ps.setString(2, entity.getName());
            ps.setString(3, entity.getValue());
            ps.setInt(4, entity.getPriority());
            ps.setString(5, entity.getStatus().getDbValue());
            ps.setString(6, entity.getDescription());
            ps.setObject(7, OffsetDateTime.now());
            ps.setLong(8, entity.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(Connection con, long id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_DELETE)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Setting mapRow(ResultSet rs) throws SQLException {
        Setting s = new Setting();
        s.setId(rs.getLong("id"));
        s.setType(SettingType.fromDb(rs.getString("type")));
        s.setName(rs.getString("name"));
        s.setValue(rs.getString("value"));
        s.setPriority(rs.getInt("priority"));
        s.setStatus(SettingStatus.fromDb(rs.getString("status")));
        s.setDescription(rs.getString("description"));
        s.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
        s.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
        return s;
    }
}
