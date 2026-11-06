package util;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Shared HTTP / Web utility methods for Servlets.
 */
public final class WebUtil {

    private WebUtil() {
    }

    /**
     * Builds the dynamic base URL (scheme://host[:port]/contextPath) from the current request.
     */
    public static String getDynamicBaseUrl(HttpServletRequest req) {
        String scheme = req.getScheme();
        String serverName = req.getServerName();
        int serverPort = req.getServerPort();
        String contextPath = req.getContextPath();
        return scheme + "://" + serverName
                + ((serverPort == 80 || serverPort == 443) ? "" : (":" + serverPort))
                + contextPath;
    }

    /**
     * Checks whether the current HTTP request is an AJAX / JSON request.
     */
    public static boolean isAjax(HttpServletRequest req) {
        String requestedWith = req.getHeader("X-Requested-With");
        String accept = req.getHeader("Accept");
        return "XMLHttpRequest".equalsIgnoreCase(requestedWith)
                || (accept != null && accept.contains("application/json"));
    }

    /**
     * Escapes special characters in a string for safe inclusion inside a JSON string literal.
     */
    public static String escapeJson(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}