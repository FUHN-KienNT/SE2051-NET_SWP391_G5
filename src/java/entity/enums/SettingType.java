package entity.enums;

public enum SettingType {
    USER_ROLE("USER_ROLE"),
    COURSE_CATEGORY("COURSE_CATEGORY");

    private final String dbValue;

    SettingType(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static SettingType fromDb(String value) {
        if (value == null) return null;
        for (SettingType item : values()) {
            if (item.dbValue.equalsIgnoreCase(value) || item.name().equalsIgnoreCase(value)) {
                return item;
            }
        }
        throw new IllegalArgumentException("Unknown SettingType: " + value);
    }
}
