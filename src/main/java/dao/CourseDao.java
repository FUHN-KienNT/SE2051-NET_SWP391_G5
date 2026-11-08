package dao;

import dto.CourseDto;
import dto.LessonDto;
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
    private static final String SQL_FIND_ALL = "SELECT id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at, archive_at, archive_notice, moderation_note, is_featured FROM courses ORDER BY id DESC";
    private static final String SQL_FIND_BY_ID = "SELECT id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at, archive_at, archive_notice, moderation_note, is_featured FROM courses WHERE id = ?";
    private static final String SQL_FIND_BY_MANAGER_OR_EXPERT = "SELECT id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at, archive_at, archive_notice, moderation_note, is_featured FROM courses WHERE manager_id = ? OR expert_id = ? ORDER BY id DESC";
    private static final String SQL_INSERT = "INSERT INTO courses (title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at, archive_at, archive_notice, moderation_note, is_featured) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING id";
    private static final String SQL_UPDATE = "UPDATE courses SET title = ?, category_id = ?, category_type = ?, description = ?, price = ?, status = ?, manager_id = ?, expert_id = ?, updated_at = ?, archive_at = ?, archive_notice = ?, moderation_note = ?, is_featured = ? WHERE id = ?";
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
        StringBuilder sql = new StringBuilder("SELECT id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at, archive_at, archive_notice, moderation_note, is_featured FROM courses WHERE status = 'PUBLISHED' AND (archive_at IS NULL OR archive_at > NOW())");
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

    public int countPublished(Connection con, String keyword, Long categoryId) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(1) FROM courses c WHERE c.status = 'PUBLISHED' AND (c.archive_at IS NULL OR c.archive_at > NOW())");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(c.title) LIKE ? OR LOWER(c.description) LIKE ?)");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (categoryId != null) {
            sql.append(" AND c.category_id = ?");
            params.add(categoryId);
        }

        try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public List<CourseDto> searchPublishedSummaries(Connection con, String keyword, Long categoryId, Integer limit, Integer offset) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT c.id, c.title, c.category_id, c.description, c.price, c.status, "
                + "c.manager_id, c.expert_id, c.archive_at, c.archive_notice, c.moderation_note, c.is_featured, "
                + "s.name AS category_name, mgr.full_name AS manager_name, exp.full_name AS expert_name, "
                + "(SELECT COUNT(1) FROM lessons l JOIN modules m ON l.module_id = m.id WHERE m.course_id = c.id AND l.is_active = TRUE) AS total_lessons, "
                + "(SELECT l2.video_url FROM lessons l2 JOIN modules m2 ON l2.module_id = m2.id WHERE m2.course_id = c.id AND l2.is_active = TRUE AND l2.video_url IS NOT NULL AND TRIM(l2.video_url) <> '' ORDER BY m2.order_index ASC, l2.order_index ASC LIMIT 1) AS first_video_url "
                + "FROM courses c "
                + "LEFT JOIN settings s ON c.category_id = s.id "
                + "LEFT JOIN users mgr ON c.manager_id = mgr.id "
                + "LEFT JOIN users exp ON c.expert_id = exp.id "
                + "WHERE c.status = 'PUBLISHED' AND (c.archive_at IS NULL OR c.archive_at > NOW())"
        );
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(c.title) LIKE ? OR LOWER(c.description) LIKE ?)");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (categoryId != null) {
            sql.append(" AND c.category_id = ?");
            params.add(categoryId);
        }
        sql.append(" ORDER BY c.id DESC");
        if (limit != null && limit > 0) {
            sql.append(" LIMIT ?");
            params.add(limit);
        }
        if (offset != null && offset >= 0) {
            sql.append(" OFFSET ?");
            params.add(offset);
        }

        List<CourseDto> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSummaryDto(rs));
                }
            }
        }
        return list;
    }

    public List<CourseDto> findFeaturedSummaries(Connection con, int limit) throws SQLException {
        String sql = "SELECT c.id, c.title, c.category_id, c.description, c.price, c.status, "
                + "c.manager_id, c.expert_id, c.archive_at, c.archive_notice, c.moderation_note, c.is_featured, "
                + "s.name AS category_name, mgr.full_name AS manager_name, exp.full_name AS expert_name, "
                + "(SELECT COUNT(1) FROM lessons l JOIN modules m ON l.module_id = m.id WHERE m.course_id = c.id AND l.is_active = TRUE) AS total_lessons, "
                + "(SELECT l2.video_url FROM lessons l2 JOIN modules m2 ON l2.module_id = m2.id WHERE m2.course_id = c.id AND l2.is_active = TRUE AND l2.video_url IS NOT NULL AND TRIM(l2.video_url) <> '' ORDER BY m2.order_index ASC, l2.order_index ASC LIMIT 1) AS first_video_url "
                + "FROM courses c "
                + "LEFT JOIN settings s ON c.category_id = s.id "
                + "LEFT JOIN users mgr ON c.manager_id = mgr.id "
                + "LEFT JOIN users exp ON c.expert_id = exp.id "
                + "WHERE c.status = 'PUBLISHED' AND c.is_featured = TRUE AND (c.archive_at IS NULL OR c.archive_at > NOW()) "
                + "ORDER BY c.updated_at DESC, c.id DESC LIMIT ?";
        List<CourseDto> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit > 0 ? limit : 6);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSummaryDto(rs));
                }
            }
        }
        return list;
    }

    private CourseDto mapSummaryDto(ResultSet rs) throws SQLException {
        CourseDto dto = new CourseDto();
        dto.setId(rs.getLong("id"));
        dto.setTitle(rs.getString("title"));
        long catId = rs.getLong("category_id");
        dto.setCategoryId(rs.wasNull() ? null : catId);
        dto.setCategoryName(rs.getString("category_name"));
        dto.setDescription(rs.getString("description"));
        dto.setPrice(rs.getBigDecimal("price"));
        dto.setStatus(CourseStatus.fromDb(rs.getString("status")));
        long mId = rs.getLong("manager_id");
        dto.setManagerId(rs.wasNull() ? null : mId);
        dto.setManagerName(rs.getString("manager_name"));
        long eId = rs.getLong("expert_id");
        dto.setExpertId(rs.wasNull() ? null : eId);
        dto.setExpertName(rs.getString("expert_name"));
        dto.setArchiveAt(rs.getObject("archive_at", OffsetDateTime.class));
        dto.setArchiveNotice(rs.getString("archive_notice"));
        dto.setModerationNote(rs.getString("moderation_note"));
        dto.setFeatured(rs.getBoolean("is_featured"));
        dto.setTotalLessonsCount(rs.getInt("total_lessons"));
        dto.setCustomThumbnailUrl(LessonDto.extractYoutubeThumbnail(rs.getString("first_video_url"), true));
        return dto;
    }

    /**
     * Tìm kiếm và lọc danh sách khóa học toàn hệ thống dành cho Admin.
     */
    public List<Course> searchAdmin(Connection con, String keyword, Long categoryId, Long managerId, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at, archive_at, archive_notice, moderation_note, is_featured FROM courses WHERE 1=1");
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

    /**
     * Lấy thông tin chi tiết một khóa học theo ID từ bảng 'courses'.
     */
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

    public List<CourseDto> findSummariesByManagerOrExpert(Connection con, long userId) throws SQLException {
        String sql = "SELECT c.id, c.title, c.category_id, c.description, c.price, c.status, "
                + "c.manager_id, c.expert_id, c.archive_at, c.archive_notice, c.moderation_note, c.is_featured, "
                + "s.name AS category_name, mgr.full_name AS manager_name, exp.full_name AS expert_name, "
                + "(SELECT COUNT(1) FROM lessons l JOIN modules m ON l.module_id = m.id WHERE m.course_id = c.id) AS total_lessons, "
                + "(SELECT COUNT(1) FROM quizzes q JOIN modules m ON q.module_id = m.id WHERE m.course_id = c.id) AS total_quizzes, "
                + "(SELECT l2.video_url FROM lessons l2 JOIN modules m2 ON l2.module_id = m2.id WHERE m2.course_id = c.id AND l2.video_url IS NOT NULL AND TRIM(l2.video_url) <> '' ORDER BY m2.order_index ASC, l2.order_index ASC LIMIT 1) AS first_video_url "
                + "FROM courses c "
                + "LEFT JOIN settings s ON c.category_id = s.id "
                + "LEFT JOIN users mgr ON c.manager_id = mgr.id "
                + "LEFT JOIN users exp ON c.expert_id = exp.id "
                + "WHERE c.manager_id = ? OR c.expert_id = ? "
                + "ORDER BY c.id DESC";

        List<CourseDto> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CourseDto dto = mapSummaryDto(rs);
                    dto.setTotalQuizzes(rs.getInt("total_quizzes"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

        // #m_ds [TRẠM 3/4 - SQL DATABASE]: SQL: "SELECT ... FROM courses WHERE manager_id = ? OR expert_id = ? ORDER BY id DESC"
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

    /**
     * Thêm mới một khóa học vào bảng 'courses'.
     */
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
            ps.setObject(11, entity.getArchiveAt());
            ps.setString(12, entity.getArchiveNotice());
            ps.setString(13, entity.getModerationNote());
            ps.setBoolean(14, entity.isFeatured());

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
     * Cập nhật thông tin khóa học, phân công Expert/Manager vào bảng 'courses'.
     */
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
            ps.setObject(10, entity.getArchiveAt());
            ps.setString(11, entity.getArchiveNotice());
            ps.setString(12, entity.getModerationNote());
            ps.setBoolean(13, entity.isFeatured());
            ps.setLong(14, entity.getId());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Tự động quét và chuyển trạng thái các khóa học đã tới hạn lưu trữ (archive_at <= NOW()).
     * Trả về số lượng khóa học đã được chuyển sang ARCHIVED.
     */
    public int archiveExpiredCourses(Connection con) throws SQLException {
        String sql = "UPDATE courses SET status = 'ARCHIVED', updated_at = NOW() " +
                     "WHERE status = 'PUBLISHED' AND archive_at IS NOT NULL AND archive_at <= NOW()";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            return ps.executeUpdate();
        }
    }

    public boolean updateArchiveStatus(Connection con, long courseId, CourseStatus status, OffsetDateTime archiveAt, String archiveNotice) throws SQLException {
        String sql = "UPDATE courses SET status = ?, archive_at = ?, archive_notice = ?, updated_at = NOW() WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status.getDbValue());
            ps.setObject(2, archiveAt);
            ps.setString(3, archiveNotice);
            ps.setLong(4, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Xóa một khóa học theo ID khỏi bảng 'courses'.
     */
    public List<Course> findFeatured(Connection con, int limit) throws SQLException {
        String sql = "SELECT id, title, category_id, category_type, description, price, status, manager_id, expert_id, created_at, updated_at, archive_at, archive_notice, moderation_note, is_featured " +
                     "FROM courses " +
                     "WHERE status = 'PUBLISHED' AND is_featured = true AND (archive_at IS NULL OR archive_at > NOW()) " +
                     "ORDER BY updated_at DESC, id DESC LIMIT ?";
        List<Course> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit > 0 ? limit : 6);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public boolean updateFeatured(Connection con, long courseId, boolean isFeatured) throws SQLException {
        String sql = "UPDATE courses SET is_featured = ?, updated_at = NOW() WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, isFeatured);
            ps.setLong(2, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    // #m_xoa [TRẠM 4/4 - SQL DATABASE]: Chạy SQL_DELETE: "DELETE FROM courses WHERE id = ?" (PostgreSQL ON DELETE CASCADE tự xóa modules & lessons)
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
        c.setArchiveAt(rs.getObject("archive_at", OffsetDateTime.class));
        c.setArchiveNotice(rs.getString("archive_notice"));
        try { c.setModerationNote(rs.getString("moderation_note")); } catch (SQLException ignored) {}
        try { c.setFeatured(rs.getBoolean("is_featured")); } catch (SQLException ignored) {}
        return c;
    }
}
