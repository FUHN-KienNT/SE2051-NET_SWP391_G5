package dto;

import java.math.BigDecimal;

public class QuizAnswerDto {
    private Long questionId;
    private Long selectedOptionId;
    private boolean correct;
    private BigDecimal score;

    public QuizAnswerDto() {
    }

    public QuizAnswerDto(Long questionId, Long selectedOptionId, boolean correct, BigDecimal score) {
        this.questionId = questionId;
        this.selectedOptionId = selectedOptionId;
        this.correct = correct;
        this.score = score;
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
