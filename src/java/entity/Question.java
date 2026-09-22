package entity;

import entity.enums.QuestionType;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

public class Question {
    private Long id;
    private Long moduleId;
    private String questionText;
    private QuestionType questionType;
    private BigDecimal defaultPoints;
    private OffsetDateTime createdAt;

    public Question() {
    }

    public Question(Long id, Long moduleId, String questionText, QuestionType questionType,
                    BigDecimal defaultPoints, OffsetDateTime createdAt) {
        this.id = id;
        this.moduleId = moduleId;
        this.questionText = questionText;
        this.questionType = questionType;
        this.defaultPoints = defaultPoints;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getModuleId() {
        return moduleId;
    }

    public void setModuleId(Long moduleId) {
        this.moduleId = moduleId;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public QuestionType getQuestionType() {
        return questionType;
    }

    public void setQuestionType(QuestionType questionType) {
        this.questionType = questionType;
    }

    public BigDecimal getDefaultPoints() {
        return defaultPoints;
    }

    public void setDefaultPoints(BigDecimal defaultPoints) {
        this.defaultPoints = defaultPoints;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
