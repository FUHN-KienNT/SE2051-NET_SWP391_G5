package dto;

import entity.enums.CourseStatus;
import entity.enums.PaymentMethod;
import entity.enums.PaymentStatus;
import entity.enums.RegistrationStatus;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

public class RegistrationDto {
    private Long id;
    private Long userId;
    private String userName;
    private Long courseId;
    private String courseTitle;
    private OffsetDateTime registrationDate;
    private BigDecimal progressPercentage;
    private RegistrationStatus status;
    private PaymentMethod paymentMethod;
    private String paymentCode;
    private BigDecimal paymentAmount;
    private PaymentStatus paymentStatus;
    private OffsetDateTime paidAt;
    private Long categoryId;
    private String categoryName;
    private String expertName;
    private int totalLessons;
    private int completedLessons;
    private boolean archived;
    private String archiveNotice;
    private Long lastLessonId;
    private String lastLessonTitle;
    private OffsetDateTime lastStudiedAt;
    private CourseStatus courseStatus;

    public RegistrationDto() {
    }

    public RegistrationDto(Long id, Long userId, String userName, Long courseId, String courseTitle,
                           OffsetDateTime registrationDate, BigDecimal progressPercentage,
                           RegistrationStatus status, PaymentMethod paymentMethod, String paymentCode,
                           BigDecimal paymentAmount, PaymentStatus paymentStatus, OffsetDateTime paidAt) {
        this.id = id;
        this.userId = userId;
        this.userName = userName;
        this.courseId = courseId;
        this.courseTitle = courseTitle;
        this.registrationDate = registrationDate;
        this.progressPercentage = progressPercentage;
        this.status = status;
        this.paymentMethod = paymentMethod;
        this.paymentCode = paymentCode;
        this.paymentAmount = paymentAmount;
        this.paymentStatus = paymentStatus;
        this.paidAt = paidAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
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

    public OffsetDateTime getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(OffsetDateTime registrationDate) {
        this.registrationDate = registrationDate;
    }

    public BigDecimal getProgressPercentage() {
        return progressPercentage;
    }

    public void setProgressPercentage(BigDecimal progressPercentage) {
        this.progressPercentage = progressPercentage;
    }

    public RegistrationStatus getStatus() {
        return status;
    }

    public void setStatus(RegistrationStatus status) {
        this.status = status;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentCode() {
        return paymentCode;
    }

    public void setPaymentCode(String paymentCode) {
        this.paymentCode = paymentCode;
    }

    public BigDecimal getPaymentAmount() {
        return paymentAmount;
    }

    public void setPaymentAmount(BigDecimal paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public OffsetDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(OffsetDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getExpertName() {
        return expertName;
    }

    public void setExpertName(String expertName) {
        this.expertName = expertName;
    }

    public int getTotalLessons() {
        return totalLessons;
    }

    public void setTotalLessons(int totalLessons) {
        this.totalLessons = totalLessons;
    }

    public int getCompletedLessons() {
        return completedLessons;
    }

    public void setCompletedLessons(int completedLessons) {
        this.completedLessons = completedLessons;
    }

    public boolean isArchived() {
        return archived;
    }

    public void setArchived(boolean archived) {
        this.archived = archived;
    }

    public String getArchiveNotice() {
        return archiveNotice;
    }

    public void setArchiveNotice(String archiveNotice) {
        this.archiveNotice = archiveNotice;
    }

    public Long getLastLessonId() {
        return lastLessonId;
    }

    public void setLastLessonId(Long lastLessonId) {
        this.lastLessonId = lastLessonId;
    }

    public String getLastLessonTitle() {
        return lastLessonTitle;
    }

    public void setLastLessonTitle(String lastLessonTitle) {
        this.lastLessonTitle = lastLessonTitle;
    }

    public OffsetDateTime getLastStudiedAt() {
        return lastStudiedAt;
    }

    public void setLastStudiedAt(OffsetDateTime lastStudiedAt) {
        this.lastStudiedAt = lastStudiedAt;
    }

    public CourseStatus getCourseStatus() {
        return courseStatus;
    }

    public void setCourseStatus(CourseStatus courseStatus) {
        this.courseStatus = courseStatus;
    }

    public String getThumbnailUrl() {
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
}
