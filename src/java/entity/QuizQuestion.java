package entity;

import java.math.BigDecimal;

public class QuizQuestion {
    private Long id;
    private Long quizId;
    private Long questionId;
    private Long moduleId;
    private int orderIndex;
    private BigDecimal points;

    public QuizQuestion() {
    }

    public QuizQuestion(Long id, Long quizId, Long questionId, Long moduleId, int orderIndex, BigDecimal points) {
        this.id = id;
        this.quizId = quizId;
        this.questionId = questionId;
        this.moduleId = moduleId;
        this.orderIndex = orderIndex;
        this.points = points;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getQuizId() {
        return quizId;
    }

    public void setQuizId(Long quizId) {
        this.quizId = quizId;
    }

    public Long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(Long questionId) {
        this.questionId = questionId;
    }

    public Long getModuleId() {
        return moduleId;
    }

    public void setModuleId(Long moduleId) {
        this.moduleId = moduleId;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }

    public BigDecimal getPoints() {
        return points;
    }

    public void setPoints(BigDecimal points) {
        this.points = points;
    }
}
