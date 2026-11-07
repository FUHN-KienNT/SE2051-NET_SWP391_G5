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
    private Long courseId;
    private String userNote;
    private boolean isActive = true;
    private String customThumbnailUrl;

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

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
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

    public void setCustomThumbnailUrl(String customThumbnailUrl) {
        this.customThumbnailUrl = customThumbnailUrl;
    }

    public static String extractYoutubeThumbnail(String videoUrl, boolean highQuality) {
        if (videoUrl != null && !videoUrl.trim().isEmpty()) {
            String url = videoUrl.trim();
            String vid = null;
            if (url.contains("embed/")) {
                vid = url.substring(url.indexOf("embed/") + 6);
                if (vid.contains("?")) vid = vid.substring(0, vid.indexOf("?"));
                if (vid.contains("&")) vid = vid.substring(0, vid.indexOf("&"));
            } else if (url.contains("v=")) {
                vid = url.substring(url.indexOf("v=") + 2);
                if (vid.contains("&")) vid = vid.substring(0, vid.indexOf("&"));
            } else if (url.contains("youtu.be/")) {
                vid = url.substring(url.indexOf("youtu.be/") + 9);
                if (vid.contains("?")) vid = vid.substring(0, vid.indexOf("?"));
            }
            if (vid != null && !vid.isEmpty()) {
                return "https://img.youtube.com/vi/" + vid + (highQuality ? "/hqdefault.jpg" : "/mqdefault.jpg");
            }
        }
        return highQuality
                ? "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=60"
                : "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&auto=format&fit=crop&q=60";
    }

    public String getThumbnailUrl() {
        if (customThumbnailUrl != null && !customThumbnailUrl.trim().isEmpty()) {
            return customThumbnailUrl;
        }
        return extractYoutubeThumbnail(this.videoUrl, false);
    }

    public String getUserNote() {
        return userNote;
    }

    public void setUserNote(String userNote) {
        this.userNote = userNote;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
    }
    public String getEmbedVideoUrl() {
        if (videoUrl == null || videoUrl.trim().isEmpty()) {
            return null;
        }
        String url = videoUrl.trim();
        if (url.contains("youtube.com/embed/")) {
            return url;
        }
        if (url.contains("v=")) {
            String vid = url.substring(url.indexOf("v=") + 2);
            if (vid.contains("&")) vid = vid.substring(0, vid.indexOf("&"));
            if (vid.contains("?")) vid = vid.substring(0, vid.indexOf("?"));
            if (!vid.isEmpty()) {
                return "https://www.youtube.com/embed/" + vid;
            }
        }
        if (url.contains("youtu.be/")) {
            String vid = url.substring(url.indexOf("youtu.be/") + 9);
            if (vid.contains("?")) vid = vid.substring(0, vid.indexOf("?"));
            if (vid.contains("&")) vid = vid.substring(0, vid.indexOf("&"));
            if (!vid.isEmpty()) {
                return "https://www.youtube.com/embed/" + vid;
            }
        }
        return url;
    }
}
