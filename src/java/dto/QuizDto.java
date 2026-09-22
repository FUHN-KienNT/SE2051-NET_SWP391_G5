package dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class QuizDto {
    private Long id;
    private Long moduleId;
    private String title;
    private BigDecimal passScore;
    private Integer timeLimitMinutes;
    private int orderIndex;
    private List<QuestionDto> questions = new ArrayList<>();

    public QuizDto() {
    }

    public QuizDto(Long id, Long moduleId, String title, BigDecimal passScore, Integer timeLimitMinutes,
                   int orderIndex, List<QuestionDto> questions) {
        this.id = id;
        this.moduleId = moduleId;
        this.title = title;
        this.passScore = passScore;
        this.timeLimitMinutes = timeLimitMinutes;
        this.orderIndex = orderIndex;
        this.questions = questions != null ? questions : new ArrayList<>();
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public BigDecimal getPassScore() {
        return passScore;
    }

    public void setPassScore(BigDecimal passScore) {
        this.passScore = passScore;
    }

    public Integer getTimeLimitMinutes() {
        return timeLimitMinutes;
    }

    public void setTimeLimitMinutes(Integer timeLimitMinutes) {
        this.timeLimitMinutes = timeLimitMinutes;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }

    public List<QuestionDto> getQuestions() {
        return questions;
    }

    public void setQuestions(List<QuestionDto> questions) {
        this.questions = questions != null ? questions : new ArrayList<>();
    }
}
