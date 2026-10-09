package dao;

import entity.Quiz;
import entity.QuizQuestion;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class QuizDao {
    private static final String SQL_FIND_BY_MODULE = "SELECT id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at FROM quizzes WHERE module_id = ? ORDER BY order_index ASC";
    private static final String SQL_FIND_BY_ID = "SELECT id, module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at FROM quizzes WHERE id = ?";
    private static final String SQL_EXISTS_ORDER = "SELECT COUNT(1) FROM quizzes WHERE module_id = ? AND order_index = ? AND (? IS NULL OR id != ?)";
    private static final String SQL_INSERT = "INSERT INTO quizzes (module_id, title, pass_score, time_limit_minutes, order_index, created_at, updated_at) OUTPUT INSERTED.id VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String SQL_UPDATE = "UPDATE quizzes SET title = ?, pass_score = ?, time_limit_minutes = ?, order_index = ?, updated_at = ? WHERE id = ?";
    private static final String SQL_DELETE = "DELETE FROM quizzes WHERE id = ?";

    private static final String SQL_FIND_ASSIGNMENTS = "SELECT id, quiz_id, question_id, module_id, order_index, points FROM quiz_questions WHERE quiz_id = ? ORDER BY order_index ASC";
    private static final String SQL_SAVE_ASSIGNMENT = "MERGE quiz_questions AS target "
            + "USING (VALUES (?, ?, ?, ?, ?)) AS source (quiz_id, question_id, module_id, order_index, points) "
            + "ON target.quiz_id = source.quiz_id AND target.question_id = source.question_id "
            + "WHEN MATCHED THEN UPDATE SET order_index = source.order_index, points = source.points "
            + "WHEN NOT MATCHED THEN INSERT (quiz_id, question_id, module_id, order_index, points) VALUES (source.quiz_id, source.question_id, source.module_id, source.order_index, source.points) "
            + "OUTPUT INSERTED.id;";
    private static final String SQL_DELETE_ASSIGNMENT = "DELETE FROM quiz_questions WHERE quiz_id = ? AND question_id = ?";
    private static final String SQL_UPDATE_ASSIGNMENT_ORDER = "UPDATE quiz_questions SET order_index = ? WHERE quiz_id = ? AND question_id = ?";

    public List<Quiz> findByModuleId(Connection con, long moduleId) throws SQLException {
        List<Quiz> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_MODULE)) {
            ps.setLong(1, moduleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapQuiz(rs));
                }
            }
        }
        return list;
    }

    public Optional<Quiz> findById(Connection con, long id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_ID)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapQuiz(rs));
                }
            }
        }
        return Optional.empty();
    }

    public boolean existsOrderIndex(Connection con, long moduleId, int order, Long excludeId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_EXISTS_ORDER)) {
            ps.setLong(1, moduleId);
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

    public long insert(Connection con, Quiz entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_INSERT)) {
            ps.setLong(1, entity.getModuleId());
            ps.setString(2, entity.getTitle());
            ps.setBigDecimal(3, entity.getPassScore() != null ? entity.getPassScore() : BigDecimal.valueOf(50.0));
            if (entity.getTimeLimitMinutes() != null) ps.setInt(4, entity.getTimeLimitMinutes());
            else ps.setNull(4, java.sql.Types.INTEGER);
            ps.setInt(5, entity.getOrderIndex());
            OffsetDateTime now = OffsetDateTime.now();
            ps.setObject(6, entity.getCreatedAt() != null ? entity.getCreatedAt() : now);
            ps.setObject(7, entity.getUpdatedAt() != null ? entity.getUpdatedAt() : now);

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

    public boolean update(Connection con, Quiz entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, entity.getTitle());
            ps.setBigDecimal(2, entity.getPassScore());
            if (entity.getTimeLimitMinutes() != null) ps.setInt(3, entity.getTimeLimitMinutes());
            else ps.setNull(3, java.sql.Types.INTEGER);
            ps.setInt(4, entity.getOrderIndex());
            ps.setObject(5, OffsetDateTime.now());
            ps.setLong(6, entity.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(Connection con, long id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_DELETE)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public List<QuizQuestion> findAssignments(Connection con, long quizId) throws SQLException {
        List<QuizQuestion> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_ASSIGNMENTS)) {
            ps.setLong(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAssignment(rs));
                }
            }
        }
        return list;
    }

    public long saveAssignment(Connection con, QuizQuestion item) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_SAVE_ASSIGNMENT)) {
            ps.setLong(1, item.getQuizId());
            ps.setLong(2, item.getQuestionId());
            ps.setLong(3, item.getModuleId());
            ps.setInt(4, item.getOrderIndex());
            ps.setBigDecimal(5, item.getPoints() != null ? item.getPoints() : BigDecimal.ONE);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    long id = rs.getLong(1);
                    item.setId(id);
                    return id;
                }
            }
        }
        return 0L;
    }

    public boolean deleteAssignment(Connection con, long quizId, long questionId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_DELETE_ASSIGNMENT)) {
            ps.setLong(1, quizId);
            ps.setLong(2, questionId);
            return ps.executeUpdate() > 0;
        }
    }

    public int getNextOrderIndex(Connection con, long quizId) throws SQLException {
        String sql = "SELECT COALESCE(MAX(order_index), 0) + 1 FROM quiz_questions WHERE quiz_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 1;
    }

    public void reorderAssignments(Connection con, long quizId, List<QuizQuestion> items) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE_ASSIGNMENT_ORDER)) {
            for (QuizQuestion item : items) {
                ps.setInt(1, item.getOrderIndex());
                ps.setLong(2, quizId);
                ps.setLong(3, item.getQuestionId());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private Quiz mapQuiz(ResultSet rs) throws SQLException {
        Quiz q = new Quiz();
        q.setId(rs.getLong("id"));
        q.setModuleId(rs.getLong("module_id"));
        q.setTitle(rs.getString("title"));
        q.setPassScore(rs.getBigDecimal("pass_score"));
        int limit = rs.getInt("time_limit_minutes");
        q.setTimeLimitMinutes(rs.wasNull() ? null : limit);
        q.setOrderIndex(rs.getInt("order_index"));
        q.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
        q.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
        return q;
    }

    private QuizQuestion mapAssignment(ResultSet rs) throws SQLException {
        QuizQuestion qq = new QuizQuestion();
        qq.setId(rs.getLong("id"));
        qq.setQuizId(rs.getLong("quiz_id"));
        qq.setQuestionId(rs.getLong("question_id"));
        qq.setModuleId(rs.getLong("module_id"));
        qq.setOrderIndex(rs.getInt("order_index"));
        qq.setPoints(rs.getBigDecimal("points"));
        return qq;
    }
}
