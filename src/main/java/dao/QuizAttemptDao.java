package dao;

import entity.QuizAnswer;
import entity.QuizAttempt;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class QuizAttemptDao {
    private static final String SQL_FIND_BY_REG_AND_QUIZ = "SELECT TOP (1) id, registration_id, quiz_id, submitted_at, total_score, pass_status FROM quiz_attempts WHERE registration_id = ? AND quiz_id = ? ORDER BY id DESC";
    private static final String SQL_INSERT_ATTEMPT = "INSERT INTO quiz_attempts (registration_id, quiz_id, submitted_at, total_score, pass_status) OUTPUT INSERTED.id VALUES (?, ?, ?, ?, ?)";
    private static final String SQL_UPDATE_ATTEMPT = "UPDATE quiz_attempts SET submitted_at = ?, total_score = ?, pass_status = ? WHERE id = ?";
    private static final String SQL_FIND_ANSWERS = "SELECT id, quiz_attempt_id, question_id, selected_option_id, is_correct, score FROM quiz_answers WHERE quiz_attempt_id = ?";
    private static final String SQL_DELETE_ANSWERS = "DELETE FROM quiz_answers WHERE quiz_attempt_id = ?";
    private static final String SQL_INSERT_ANSWER = "INSERT INTO quiz_answers (quiz_attempt_id, question_id, selected_option_id, is_correct, score) OUTPUT INSERTED.id VALUES (?, ?, ?, ?, ?)";

    public Optional<QuizAttempt> findByRegistrationAndQuiz(Connection con, long registrationId, long quizId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_BY_REG_AND_QUIZ)) {
            ps.setLong(1, registrationId);
            ps.setLong(2, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapAttempt(rs));
                }
            }
        }
        return Optional.empty();
    }

    public List<QuizAnswer> findAnswers(Connection con, long attemptId) throws SQLException {
        List<QuizAnswer> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SQL_FIND_ANSWERS)) {
            ps.setLong(1, attemptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAnswer(rs));
                }
            }
        }
        return list;
    }

    public long upsertAttempt(Connection con, QuizAttempt entity) throws SQLException {
        if (entity.getId() != null && entity.getId() > 0) {
            try (PreparedStatement ps = con.prepareStatement(SQL_UPDATE_ATTEMPT)) {
                ps.setObject(1, entity.getSubmittedAt() != null ? entity.getSubmittedAt() : OffsetDateTime.now());
                ps.setBigDecimal(2, entity.getTotalScore() != null ? entity.getTotalScore() : BigDecimal.ZERO);
                ps.setBoolean(3, entity.isPassStatus());
                ps.setLong(4, entity.getId());
                ps.executeUpdate();
                return entity.getId();
            }
        } else {
            try (PreparedStatement ps = con.prepareStatement(SQL_INSERT_ATTEMPT)) {
                ps.setLong(1, entity.getRegistrationId());
                ps.setLong(2, entity.getQuizId());
                ps.setObject(3, entity.getSubmittedAt() != null ? entity.getSubmittedAt() : OffsetDateTime.now());
                ps.setBigDecimal(4, entity.getTotalScore() != null ? entity.getTotalScore() : BigDecimal.ZERO);
                ps.setBoolean(5, entity.isPassStatus());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        long id = rs.getLong(1);
                        entity.setId(id);
                        return id;
                    }
                }
            }
        }
        return 0L;
    }

    public void replaceAnswers(Connection con, long attemptId, List<QuizAnswer> answers) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_DELETE_ANSWERS)) {
            ps.setLong(1, attemptId);
            ps.executeUpdate();
        }
        if (answers != null) {
            for (QuizAnswer answer : answers) {
                answer.setQuizAttemptId(attemptId);
                insertAnswer(con, answer);
            }
        }
    }

    private long insertAnswer(Connection con, QuizAnswer answer) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(SQL_INSERT_ANSWER)) {
            ps.setLong(1, answer.getQuizAttemptId());
            ps.setLong(2, answer.getQuestionId());
            if (answer.getSelectedOptionId() != null) ps.setLong(3, answer.getSelectedOptionId());
            else ps.setNull(3, java.sql.Types.BIGINT);
            ps.setBoolean(4, answer.isCorrect());
            ps.setBigDecimal(5, answer.getScore() != null ? answer.getScore() : BigDecimal.ZERO);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    long id = rs.getLong(1);
                    answer.setId(id);
                    return id;
                }
            }
        }
        return 0L;
    }

    private QuizAttempt mapAttempt(ResultSet rs) throws SQLException {
        QuizAttempt qa = new QuizAttempt();
        qa.setId(rs.getLong("id"));
        qa.setRegistrationId(rs.getLong("registration_id"));
        qa.setQuizId(rs.getLong("quiz_id"));
        qa.setSubmittedAt(rs.getObject("submitted_at", OffsetDateTime.class));
        qa.setTotalScore(rs.getBigDecimal("total_score"));
        qa.setPassStatus(rs.getBoolean("pass_status"));
        return qa;
    }

    private QuizAnswer mapAnswer(ResultSet rs) throws SQLException {
        QuizAnswer a = new QuizAnswer();
        a.setId(rs.getLong("id"));
        a.setQuizAttemptId(rs.getLong("quiz_attempt_id"));
        a.setQuestionId(rs.getLong("question_id"));
        long optId = rs.getLong("selected_option_id");
        a.setSelectedOptionId(rs.wasNull() ? null : optId);
        a.setCorrect(rs.getBoolean("is_correct"));
        a.setScore(rs.getBigDecimal("score"));
        return a;
    }
}
