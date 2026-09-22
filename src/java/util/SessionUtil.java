package util;

import dto.UserDto;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public final class SessionUtil {
    private static final String CURRENT_USER = "CURRENT_USER";

    private SessionUtil() {
    }

    public static void setCurrentUser(HttpServletRequest req, UserDto user) {
        if (req != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute(CURRENT_USER, user);
        }
    }

    public static UserDto getCurrentUser(HttpServletRequest req) {
        if (req == null) return null;
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        Object user = session.getAttribute(CURRENT_USER);
        return (user instanceof UserDto) ? (UserDto) user : null;
    }

    public static Long getCurrentUserId(HttpServletRequest req) {
        UserDto user = getCurrentUser(req);
        return user != null ? user.getId() : null;
    }

    public static String getCurrentRole(HttpServletRequest req) {
        UserDto user = getCurrentUser(req);
        return user != null ? user.getRoleName() : null;
    }

    public static void invalidate(HttpServletRequest req) {
        if (req != null) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
        }
    }
}
