package entity;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public class Quiz {
    private Long id;
    private Long moduleId;
    private String title;
    private BigDecimal passScore;
    private Integer timeLimitMinutes;
    private int orderIndex;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;

    public Quiz() {
    }

    public Quiz(Long id, Long moduleId, String title, BigDecimal passScore, Integer timeLimitMinutes,
                int orderIndex, OffsetDateTime createdAt, OffsetDateTime updatedAt) {
        this.id = id;
        this.moduleId = moduleId;
        this.title = title;
        this.passScore = passScore;
        this.timeLimitMinutes = timeLimitMinutes;
        this.orderIndex = orderIndex;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
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

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
