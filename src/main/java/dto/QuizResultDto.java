package dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class QuizResultDto {
    private String quizTitle;
    private BigDecimal totalScore;
    private BigDecimal maxScore;
    private BigDecimal percentage;
    private boolean passStatus;
    private List<QuizAnswerDto> answers = new ArrayList<>();

    public QuizResultDto() {
    }

    public QuizResultDto(String quizTitle, BigDecimal totalScore, BigDecimal maxScore,
                         BigDecimal percentage, boolean passStatus, List<QuizAnswerDto> answers) {
        this.quizTitle = quizTitle;
        this.totalScore = totalScore;
        this.maxScore = maxScore;
        this.percentage = percentage;
        this.passStatus = passStatus;
        this.answers = answers != null ? answers : new ArrayList<>();
    }

    public String getQuizTitle() {
        return quizTitle;
    }

    public void setQuizTitle(String quizTitle) {
        this.quizTitle = quizTitle;
    }

    public BigDecimal getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(BigDecimal totalScore) {
        this.totalScore = totalScore;
    }

    public BigDecimal getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(BigDecimal maxScore) {
        this.maxScore = maxScore;
    }

    public BigDecimal getPercentage() {
        return percentage;
    }

    public void setPercentage(BigDecimal percentage) {
        this.percentage = percentage;
    }

    public boolean isPassStatus() {
        return passStatus;
    }

    public void setPassStatus(boolean passStatus) {
        this.passStatus = passStatus;
    }

    public List<QuizAnswerDto> getAnswers() {
        return answers;
    }

    public void setAnswers(List<QuizAnswerDto> answers) {
        this.answers = answers != null ? answers : new ArrayList<>();
    }
}
