package entity.enums;

public enum LessonProgressStatus {
    NOT_STARTED("NOT_STARTED"),
    IN_PROGRESS("IN_PROGRESS"),
    COMPLETED("COMPLETED");

    private final String dbValue;

    LessonProgressStatus(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static LessonProgressStatus fromDb(String value) {
        if (value == null) return null;
        for (LessonProgressStatus item : values()) {
            if (item.dbValue.equalsIgnoreCase(value) || item.name().equalsIgnoreCase(value)) {
                return item;
            }
        }
        throw new IllegalArgumentException("Unknown LessonProgressStatus: " + value);
    }
}
