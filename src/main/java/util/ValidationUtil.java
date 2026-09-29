package util;

import java.math.BigDecimal;
import java.util.regex.Pattern;

public final class ValidationUtil {

    private static final Pattern EMAIL_PATTERN
            = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private static final Pattern PASSWORD_PATTERN
            = Pattern.compile("^(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()\\-_=+\\[\\]{};':\"\\\\|,.<>/?]).{8,32}$");

    private static final Pattern USERNAME_PATTERN
            = Pattern.compile("^[a-zA-Z0-9_]{4,30}$");

    private ValidationUtil() {
    }

    public static void requireText(String value, String field) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(field + " is required.");
        }
    }

    public static void requirePositive(BigDecimal value, String field) {
        if (value == null || value.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException(field + " must be non-negative.");
        }
    }

    public static void requireRange(BigDecimal value, BigDecimal min, BigDecimal max, String field) {
        if (value == null
                || (min != null && value.compareTo(min) < 0)
                || (max != null && value.compareTo(max) > 0)) {
            throw new IllegalArgumentException(field + " must be between " + min + " and " + max + ".");
        }
    }

    public static boolean isEmail(String value) {
        if (value == null || value.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(value.trim()).matches();
    }

    public static boolean isStrongPassword(String password) {
        if (password == null) {
            return false;
        }
        return PASSWORD_PATTERN.matcher(password).matches();
    }

    public static boolean isValidUsername(String username) {
        if (username == null) {
            return false;
        }
        return USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    public static boolean isValidFullName(String fullName) {
        if (fullName == null) {
            return false;
        }
        String s = fullName.trim();
        return s.length() >= 3 && s.length() <= 50;
    }

    public static long parseLong(String value, String field) {
        requireText(value, field);
        try {
            return Long.parseLong(value.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(field + " must be a valid number.");
        }
    }

    public static int parseInteger(String value, String field) {
        requireText(value, field);
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(field + " must be a valid integer.");
        }
    }
}
