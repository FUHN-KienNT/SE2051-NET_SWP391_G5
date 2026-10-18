package dto;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;

public class RecentLearningDto {
    private Long registrationId;
    private Long courseId;
    private String courseTitle;
    private String categoryName;
    private Long lessonId;
    private String lessonTitle;
    private String videoUrl;
    private BigDecimal progressPercentage;
    private int completedLessons;
    private int totalLessons;
    private OffsetDateTime lastStudiedAt;

    public RecentLearningDto() {
    }

    public RecentLearningDto(Long registrationId, Long courseId, String courseTitle, String categoryName,
                             Long lessonId, String lessonTitle, String videoUrl, BigDecimal progressPercentage,
                             int completedLessons, int totalLessons, OffsetDateTime lastStudiedAt) {
        this.registrationId = registrationId;
        this.courseId = courseId;
        this.courseTitle = courseTitle;
        this.categoryName = categoryName;
        this.lessonId = lessonId;
        this.lessonTitle = lessonTitle;
        this.videoUrl = videoUrl;
        this.progressPercentage = progressPercentage != null ? progressPercentage : BigDecimal.ZERO;
        this.completedLessons = completedLessons;
        this.totalLessons = totalLessons;
        this.lastStudiedAt = lastStudiedAt;
    }

    public Long getRegistrationId() {
        return registrationId;
    }

    public void setRegistrationId(Long registrationId) {
        this.registrationId = registrationId;
    }

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public String getCourseTitle() {
        return courseTitle;
    }

    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Long getLessonId() {
        return lessonId;
    }

    public void setLessonId(Long lessonId) {
        this.lessonId = lessonId;
    }

    public String getLessonTitle() {
        return lessonTitle;
    }

    public void setLessonTitle(String lessonTitle) {
        this.lessonTitle = lessonTitle;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public BigDecimal getProgressPercentage() {
        return progressPercentage != null ? progressPercentage : BigDecimal.ZERO;
    }

    public void setProgressPercentage(BigDecimal progressPercentage) {
        this.progressPercentage = progressPercentage;
    }

    public int getCompletedLessons() {
        return completedLessons;
    }

    public void setCompletedLessons(int completedLessons) {
        this.completedLessons = completedLessons;
    }

    public int getTotalLessons() {
        return totalLessons;
    }

    public void setTotalLessons(int totalLessons) {
        this.totalLessons = totalLessons;
    }

    public OffsetDateTime getLastStudiedAt() {
        return lastStudiedAt;
    }

    public void setLastStudiedAt(OffsetDateTime lastStudiedAt) {
        this.lastStudiedAt = lastStudiedAt;
    }

    public String getThumbnailUrl() {
        if (videoUrl != null && !videoUrl.trim().isEmpty()) {
            String url = videoUrl.trim();
            if (url.contains("embed/")) {
                String vid = url.substring(url.indexOf("embed/") + 6);
                if (vid.contains("?")) vid = vid.substring(0, vid.indexOf("?"));
                if (vid.contains("&")) vid = vid.substring(0, vid.indexOf("&"));
                if (!vid.isEmpty()) {
                    return "https://img.youtube.com/vi/" + vid + "/hqdefault.jpg";
                }
            } else if (url.contains("v=")) {
                String vid = url.substring(url.indexOf("v=") + 2);
                if (vid.contains("&")) vid = vid.substring(0, vid.indexOf("&"));
                if (!vid.isEmpty()) {
                    return "https://img.youtube.com/vi/" + vid + "/hqdefault.jpg";
                }
            } else if (url.contains("youtu.be/")) {
                String vid = url.substring(url.indexOf("youtu.be/") + 9);
                if (vid.contains("?")) vid = vid.substring(0, vid.indexOf("?"));
                if (!vid.isEmpty()) {
                    return "https://img.youtube.com/vi/" + vid + "/hqdefault.jpg";
                }
            }
        }
        if (courseTitle != null) {
            String lower = courseTitle.toLowerCase();
            if (lower.contains("nhân tướng") || lower.contains("viên minh")) {
                return "https://img.youtube.com/vi/WVPVpNDKUwM/hqdefault.jpg";
            }
            if (lower.contains("tử vi") || lower.contains("tvk6")) {
                return "https://img.youtube.com/vi/p3HlEXDp0vU/hqdefault.jpg";
            }
            if (lower.contains("hoàng đạo") || lower.contains("xà phu")) {
                return "https://img.youtube.com/vi/qJYOYE3uzJc/hqdefault.jpg";
            }
        }
        return "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=60";
    }

    public String getFormattedLastStudied() {
        if (lastStudiedAt == null) return "Chưa bắt đầu";
        return lastStudiedAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
