package entity;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public class QuizAttempt {
    private Long id;
    private Long registrationId;
    private Long quizId;
    private OffsetDateTime submittedAt;
    private BigDecimal totalScore;
    private boolean passStatus;

    public QuizAttempt() {
    }

    public QuizAttempt(Long id, Long registrationId, Long quizId, OffsetDateTime submittedAt,
                       BigDecimal totalScore, boolean passStatus) {
        this.id = id;
        this.registrationId = registrationId;
        this.quizId = quizId;
        this.submittedAt = submittedAt;
        this.totalScore = totalScore;
        this.passStatus = passStatus;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getRegistrationId() {
        return registrationId;
    }

    public void setRegistrationId(Long registrationId) {
        this.registrationId = registrationId;
    }

    public Long getQuizId() {
        return quizId;
    }

    public void setQuizId(Long quizId) {
        this.quizId = quizId;
    }

    public OffsetDateTime getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(OffsetDateTime submittedAt) {
        this.submittedAt = submittedAt;
    }

    public BigDecimal getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(BigDecimal totalScore) {
        this.totalScore = totalScore;
    }

    public boolean isPassStatus() {
        return passStatus;
    }

    public void setPassStatus(boolean passStatus) {
        this.passStatus = passStatus;
    }
}
