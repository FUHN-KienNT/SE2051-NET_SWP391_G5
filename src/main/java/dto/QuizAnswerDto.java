package dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class QuizAnswerDto {
    private Long questionId;
    private Long selectedOptionId;
    private List<Long> selectedOptionIds = new ArrayList<>();
    private boolean correct;
    private BigDecimal score;

    public QuizAnswerDto() {
    }

    public QuizAnswerDto(Long questionId, Long selectedOptionId, boolean correct, BigDecimal score) {
        this.questionId = questionId;
        this.selectedOptionId = selectedOptionId;
        if (selectedOptionId != null) {
            this.selectedOptionIds.add(selectedOptionId);
        }
        this.correct = correct;
        this.score = score;
    }

    public QuizAnswerDto(Long questionId, List<Long> selectedOptionIds, boolean correct, BigDecimal score) {
        this.questionId = questionId;
        this.selectedOptionIds = selectedOptionIds != null ? selectedOptionIds : new ArrayList<>();
        if (!this.selectedOptionIds.isEmpty()) {
            this.selectedOptionId = this.selectedOptionIds.get(0);
        }
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
        if (selectedOptionId != null && (selectedOptionIds == null || selectedOptionIds.isEmpty())) {
            this.selectedOptionIds = new ArrayList<>();
            this.selectedOptionIds.add(selectedOptionId);
        }
    }

    public List<Long> getSelectedOptionIds() {
        return selectedOptionIds;
    }

    public void setSelectedOptionIds(List<Long> selectedOptionIds) {
        this.selectedOptionIds = selectedOptionIds != null ? selectedOptionIds : new ArrayList<>();
        if (!this.selectedOptionIds.isEmpty()) {
            this.selectedOptionId = this.selectedOptionIds.get(0);
        }
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

    public boolean hasSelectedOption(Long optionId) {
        if (optionId == null) return false;
        if (selectedOptionIds != null && selectedOptionIds.contains(optionId)) {
            return true;
        }
        return selectedOptionId != null && selectedOptionId.equals(optionId);
    }
}
