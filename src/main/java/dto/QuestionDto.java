package dto;

import entity.enums.QuestionType;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class QuestionDto {
    private Long id;
    private Long moduleId;
    private String questionText;
    private QuestionType questionType;
    private BigDecimal defaultPoints;
    private BigDecimal assignedPoints;
    private Integer quizOrderIndex;
    private List<AnswerOptionDto> options = new ArrayList<>();

    public QuestionDto() {
    }

    public QuestionDto(Long id, Long moduleId, String questionText, QuestionType questionType,
                       BigDecimal defaultPoints, BigDecimal assignedPoints, Integer quizOrderIndex,
                       List<AnswerOptionDto> options) {
        this.id = id;
        this.moduleId = moduleId;
        this.questionText = questionText;
        this.questionType = questionType;
        this.defaultPoints = defaultPoints;
        this.assignedPoints = assignedPoints;
        this.quizOrderIndex = quizOrderIndex;
        this.options = options != null ? options : new ArrayList<>();
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

    public BigDecimal getAssignedPoints() {
        return assignedPoints;
    }

    public void setAssignedPoints(BigDecimal assignedPoints) {
        this.assignedPoints = assignedPoints;
    }

    public Integer getQuizOrderIndex() {
        return quizOrderIndex;
    }

    public void setQuizOrderIndex(Integer quizOrderIndex) {
        this.quizOrderIndex = quizOrderIndex;
    }

    public List<AnswerOptionDto> getOptions() {
        return options;
    }

    public void setOptions(List<AnswerOptionDto> options) {
        this.options = options != null ? options : new ArrayList<>();
    }
}
