package service;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

public class ValidationException extends RuntimeException {

    private final Map<String, String> errors;

    public ValidationException(Map<String, String> errors) {
        super(buildSummary(errors));
        this.errors = errors != null ? Collections.unmodifiableMap(new LinkedHashMap<>(errors)) : Collections.emptyMap();
    }

    public ValidationException(String field, String message) {
        super(message);
        Map<String, String> map = new LinkedHashMap<>();
        map.put(field, message);
        this.errors = Collections.unmodifiableMap(map);
    }

    public Map<String, String> getErrors() {
        return errors;
    }

    private static String buildSummary(Map<String, String> errors) {
        if (errors == null || errors.isEmpty()) {
            return "Dữ liệu không hợp lệ.";
        }
        return errors.values().iterator().next();
    }
}