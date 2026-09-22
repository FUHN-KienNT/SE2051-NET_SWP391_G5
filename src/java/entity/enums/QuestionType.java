package entity.enums;

public enum QuestionType {
    SINGLE_CHOICE("SINGLE_CHOICE"),
    MULTI_CHOICE("MULTI_CHOICE"),
    TRUE_FALSE("TRUE_FALSE");

    private final String dbValue;

    QuestionType(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static QuestionType fromDb(String value) {
        if (value == null) return null;
        for (QuestionType item : values()) {
            if (item.dbValue.equalsIgnoreCase(value) || item.name().equalsIgnoreCase(value)) {
                return item;
            }
        }
        throw new IllegalArgumentException("Unknown QuestionType: " + value);
    }
}
