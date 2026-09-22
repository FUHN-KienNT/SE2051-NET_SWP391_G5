package entity;

import entity.enums.SettingStatus;
import entity.enums.SettingType;
import java.time.OffsetDateTime;

public class Setting {
    private Long id;
    private SettingType type;
    private String name;
    private String value;
    private int priority;
    private SettingStatus status;
    private String description;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;

    public Setting() {
    }

    public Setting(Long id, SettingType type, String name, String value, int priority,
                   SettingStatus status, String description, OffsetDateTime createdAt, OffsetDateTime updatedAt) {
        this.id = id;
        this.type = type;
        this.name = name;
        this.value = value;
        this.priority = priority;
        this.status = status;
        this.description = description;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public SettingType getType() {
        return type;
    }

    public void setType(SettingType type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public SettingStatus getStatus() {
        return status;
    }

    public void setStatus(SettingStatus status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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
