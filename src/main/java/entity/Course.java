package entity;

import entity.enums.CourseStatus;
import entity.enums.SettingType;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

public class Course {
    private Long id;
    private String title;
    private Long categoryId;
    private SettingType categoryType;
    private String description;
    private BigDecimal price;
    private CourseStatus status;
    private Long managerId;
    private Long expertId;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
    private OffsetDateTime archiveAt;
    private String archiveNotice;

    public Course() {
    }

    public Course(Long id, String title, Long categoryId, SettingType categoryType, String description,
                  BigDecimal price, CourseStatus status, Long managerId, Long expertId,
                  OffsetDateTime createdAt, OffsetDateTime updatedAt) {
        this.id = id;
        this.title = title;
        this.categoryId = categoryId;
        this.categoryType = categoryType;
        this.description = description;
        this.price = price;
        this.status = status;
        this.managerId = managerId;
        this.expertId = expertId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Course(Long id, String title, Long categoryId, SettingType categoryType, String description,
                  BigDecimal price, CourseStatus status, Long managerId, Long expertId,
                  OffsetDateTime createdAt, OffsetDateTime updatedAt,
                  OffsetDateTime archiveAt, String archiveNotice) {
        this(id, title, categoryId, categoryType, description, price, status, managerId, expertId, createdAt, updatedAt);
        this.archiveAt = archiveAt;
        this.archiveNotice = archiveNotice;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public SettingType getCategoryType() {
        return categoryType;
    }

    public void setCategoryType(SettingType categoryType) {
        this.categoryType = categoryType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public CourseStatus getStatus() {
        return status;
    }

    public void setStatus(CourseStatus status) {
        this.status = status;
    }

    public Long getManagerId() {
        return managerId;
    }

    public void setManagerId(Long managerId) {
        this.managerId = managerId;
    }

    public Long getExpertId() {
        return expertId;
    }

    public void setExpertId(Long expertId) {
        this.expertId = expertId;
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

    public OffsetDateTime getArchiveAt() {
        return archiveAt;
    }

    public void setArchiveAt(OffsetDateTime archiveAt) {
        this.archiveAt = archiveAt;
    }

    public String getArchiveNotice() {
        return archiveNotice;
    }

    public void setArchiveNotice(String archiveNotice) {
        this.archiveNotice = archiveNotice;
    }
}
