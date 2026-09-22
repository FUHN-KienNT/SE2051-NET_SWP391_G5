package entity.enums;

public enum AuthProvider {
    LOCAL("LOCAL"),
    GOOGLE("GOOGLE");

    private final String dbValue;

    AuthProvider(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static AuthProvider fromDb(String value) {
        if (value == null) return null;
        for (AuthProvider item : values()) {
            if (item.dbValue.equalsIgnoreCase(value) || item.name().equalsIgnoreCase(value)) {
                return item;
            }
        }
        throw new IllegalArgumentException("Unknown AuthProvider: " + value);
    }
}
