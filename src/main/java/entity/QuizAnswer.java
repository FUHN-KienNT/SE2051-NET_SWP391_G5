package entity;

import java.math.BigDecimal;

public class QuizAnswer {
    private Long id;
    private Long quizAttemptId;
    private Long questionId;
    private Long selectedOptionId;
    private boolean correct;
    private BigDecimal score;

    public QuizAnswer() {
    }

    public QuizAnswer(Long id, Long quizAttemptId, Long questionId, Long selectedOptionId, boolean correct, BigDecimal score) {
        this.id = id;
        this.quizAttemptId = quizAttemptId;
        this.questionId = questionId;
        this.selectedOptionId = selectedOptionId;
        this.correct = correct;
        this.score = score;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getQuizAttemptId() {
        return quizAttemptId;
    }

    public void setQuizAttemptId(Long quizAttemptId) {
        this.quizAttemptId = quizAttemptId;
    }

    public Long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(Long questionId) {
        this.questionId = questionId;
    }

    public Long getSelectedOptionId() {
        return selectedOptionId;
    }

    public void setSelectedOptionId(Long selectedOptionId) {
        this.selectedOptionId = selectedOptionId;
    }

    public boolean isCorrect() {
        return correct;
    }

    public void setCorrect(boolean correct) {
        this.correct = correct;
    }

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }
}
