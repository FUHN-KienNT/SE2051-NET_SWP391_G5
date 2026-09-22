package entity.enums;

public enum PaymentMethod {
    SEPAY("SEPAY"),
    VNPAY("VNPAY");

    private final String dbValue;

    PaymentMethod(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static PaymentMethod fromDb(String value) {
        if (value == null) return null;
        for (PaymentMethod item : values()) {
            if (item.dbValue.equalsIgnoreCase(value) || item.name().equalsIgnoreCase(value)) {
                return item;
            }
        }
        throw new IllegalArgumentException("Unknown PaymentMethod: " + value);
    }
}
