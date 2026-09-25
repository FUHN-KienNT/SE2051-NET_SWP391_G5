package dto;

import entity.enums.LessonProgressStatus;
import java.time.OffsetDateTime;

public class LessonProgressDto {
    private Long id;
    private Long registrationId;
    private Long lessonId;
    private LessonProgressStatus status;
    private OffsetDateTime completedAt;

    public LessonProgressDto() {
    }

    public LessonProgressDto(Long id, Long registrationId, Long lessonId,
                             LessonProgressStatus status, OffsetDateTime completedAt) {
        this.id = id;
        this.registrationId = registrationId;
        this.lessonId = lessonId;
        this.status = status;
        this.completedAt = completedAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getRegistrationId() {
        return registrationId;
    }

    public void setRegistrationId(Long registrationId) {
        this.registrationId = registrationId;
    }

    public Long getLessonId() {
        return lessonId;
    }

    public void setLessonId(Long lessonId) {
        this.lessonId = lessonId;
    }

    public LessonProgressStatus getStatus() {
        return status;
    }

    public void setStatus(LessonProgressStatus status) {
        this.status = status;
    }

    public OffsetDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(OffsetDateTime completedAt) {
        this.completedAt = completedAt;
    }
}
