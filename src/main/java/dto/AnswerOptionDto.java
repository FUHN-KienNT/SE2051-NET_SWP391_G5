package dto;

public class AnswerOptionDto {
    private Long id;
    private Long questionId;
    private String optionText;
    private boolean correct;
    private int orderIndex;

    public AnswerOptionDto() {
    }

    public AnswerOptionDto(Long id, Long questionId, String optionText, boolean correct, int orderIndex) {
        this.id = id;
        this.questionId = questionId;
        this.optionText = optionText;
        this.correct = correct;
        this.orderIndex = orderIndex;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getQuestionId() {
        return questionId;
    }

    public void setQuestionId(Long questionId) {
        this.questionId = questionId;
    }

    public String getOptionText() {
        return optionText;
    }

    public void setOptionText(String optionText) {
        this.optionText = optionText;
    }

    public boolean isCorrect() {
        return correct;
    }

    public void setCorrect(boolean correct) {
        this.correct = correct;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }
}
