package dao;

import entity.AnswerOption;
import entity.Question;
import entity.enums.QuestionType;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class QuestionDao {
    private static final String SQL_FIND_BY_MODULE = "SELECT id, module_id, question_text, question_type, default_points, created_at FROM questions WHERE module_id = ? ORDER BY id ASC";
    private static final String SQL_FIND_BY_COURSE = "SELECT q.id, q.module_id, q.question_text, q.question_type, q.default_points, q.created_at FROM questions q JOIN modules m ON q.module_id = m.id WHERE m.course_id = ? ORDER BY m.order_index ASC, q.id ASC";
    private static final String SQL_FIND_BY_ID = "SELECT id, module_id, question_text, question_type, default_points, created_at FROM questions WHERE id = ?";
    private static final String SQL_INSERT = "INSERT INTO questions (module_id, question_text, question_type, default_points, created_at) VALUES (?, ?, ?, ?, ?) RETURNING id";
    private static final String SQL_UPDATE = "UPDATE questions SET question_text = ?, question_type = ?, default_points = ? WHERE id = ?";
    private static final String SQL_DELETE = "DELETE FROM questions WHERE id = ?";

    private static final String SQL_FIND_OPTIONS = "SELECT id, question_id, option_text, is_correct, order_index FROM answer_options WHERE question_id = ? ORDER BY order_index ASC";
    private static final String SQL_DELETE_OPTIONS = "DELETE FROM answer_options WHERE question_id = ?";
    private static final String SQL_INSERT_OPTION = "INSERT INTO answer_options (question_id, option_text, is_correct, order_index) VALUES (?, ?, ?, ?) RETURNING id";

    public List<Question> findByModuleId(Connection con, long moduleId) throws SQLException {
        List<Question> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_MODULE)) {
            ps.setLong(1, moduleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapQuestion(rs));
                }
            }
        }
        return list;
    }

    public List<Question> findByCourseId(Connection con, long courseId) throws SQLException {
        List<Question> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_COURSE)) {
            ps.setLong(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapQuestion(rs));
                }
            }
        }
        return list;
    }

    public Optional<Question> findById(Connection con, long id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_ID)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapQuestion(rs));
                }
            }
        }
        return Optional.empty();
    }

    public long insert(Connection con, Question entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_INSERT)) {
            ps.setLong(1, entity.getModuleId());
            ps.setString(2, entity.getQuestionText());
            ps.setString(3, entity.getQuestionType().getDbValue());
            ps.setBigDecimal(4, entity.getDefaultPoints() != null ? entity.getDefaultPoints() : BigDecimal.ONE);
            OffsetDateTime now = OffsetDateTime.now();
            ps.setObject(5, entity.getCreatedAt() != null ? entity.getCreatedAt() : now);
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

    public boolean update(Connection con, Question entity) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, entity.getQuestionText());
            ps.setString(2, entity.getQuestionType().getDbValue());
            ps.setBigDecimal(3, entity.getDefaultPoints() != null ? entity.getDefaultPoints() : BigDecimal.ONE);
            ps.setLong(4, entity.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(Connection con, long id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_DELETE)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public List<AnswerOption> findOptions(Connection con, long questionId) throws SQLException {
        List<AnswerOption> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_OPTIONS)) {
            ps.setLong(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapOption(rs));
                }
            }
        }
        return list;
    }

    public void replaceOptions(Connection con, long questionId, List<AnswerOption> options) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_DELETE_OPTIONS)) {
            ps.setLong(1, questionId);
            ps.executeUpdate();
        }
        if (options != null) {
            for (AnswerOption opt : options) {
                opt.setQuestionId(questionId);
                insertOption(con, opt);
            }
        }
    }

    private long insertOption(Connection con, AnswerOption option) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_INSERT_OPTION)) {
            ps.setLong(1, option.getQuestionId());
            ps.setString(2, option.getOptionText());
            ps.setBoolean(3, option.isCorrect());
            ps.setInt(4, option.getOrderIndex());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    long id = rs.getLong(1);
                    option.setId(id);
                    return id;
                }
            }
        }
        return 0L;
    }

    private Question mapQuestion(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setId(rs.getLong("id"));
        q.setModuleId(rs.getLong("module_id"));
        q.setQuestionText(rs.getString("question_text"));
        q.setQuestionType(QuestionType.fromDb(rs.getString("question_type")));
        q.setDefaultPoints(rs.getBigDecimal("default_points"));
        q.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
        return q;
    }

    private AnswerOption mapOption(ResultSet rs) throws SQLException {
        AnswerOption ao = new AnswerOption();
        ao.setId(rs.getLong("id"));
        ao.setQuestionId(rs.getLong("question_id"));
        ao.setOptionText(rs.getString("option_text"));
        ao.setCorrect(rs.getBoolean("is_correct"));
        ao.setOrderIndex(rs.getInt("order_index"));
        return ao;
    }
}
