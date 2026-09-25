package entity.enums;

public enum RegistrationStatus {
    PENDING("PENDING"),
    ACTIVE("ACTIVE"),
    COMPLETED("COMPLETED"),
    CANCELLED("CANCELLED");

    private final String dbValue;

    RegistrationStatus(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static RegistrationStatus fromDb(String value) {
        if (value == null) return null;
        for (RegistrationStatus item : values()) {
            if (item.dbValue.equalsIgnoreCase(value) || item.name().equalsIgnoreCase(value)) {
                return item;
            }
        }
        throw new IllegalArgumentException("Unknown RegistrationStatus: " + value);
    }
}
