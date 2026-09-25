package dto;

import entity.enums.LessonProgressStatus;

public class LessonDto {
    private Long id;
    private Long moduleId;
    private String title;
    private String content;
    private String videoUrl;
    private String documentUrl;
    private int orderIndex;
    private LessonProgressStatus progressStatus;

    public LessonDto() {
    }

    public LessonDto(Long id, Long moduleId, String title, String content, String videoUrl,
                     String documentUrl, int orderIndex, LessonProgressStatus progressStatus) {
        this.id = id;
        this.moduleId = moduleId;
        this.title = title;
        this.content = content;
        this.videoUrl = videoUrl;
        this.documentUrl = documentUrl;
        this.orderIndex = orderIndex;
        this.progressStatus = progressStatus;
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public String getDocumentUrl() {
        return documentUrl;
    }

    public void setDocumentUrl(String documentUrl) {
        this.documentUrl = documentUrl;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }

    public LessonProgressStatus getProgressStatus() {
        return progressStatus;
    }

    public void setProgressStatus(LessonProgressStatus progressStatus) {
        this.progressStatus = progressStatus;
    }
}
