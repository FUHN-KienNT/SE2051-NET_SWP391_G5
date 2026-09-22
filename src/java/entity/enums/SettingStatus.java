package entity.enums;

public enum SettingStatus {
    ACTIVE("ACTIVE"),
    INACTIVE("INACTIVE");

    private final String dbValue;

    SettingStatus(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static SettingStatus fromDb(String value) {
        if (value == null) return null;
        for (SettingStatus item : values()) {
            if (item.dbValue.equalsIgnoreCase(value) || item.name().equalsIgnoreCase(value)) {
                return item;
            }
        }
        throw new IllegalArgumentException("Unknown SettingStatus: " + value);
    }
}
