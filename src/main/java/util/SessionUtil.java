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

    public static void setFlashError(HttpServletRequest req, String message) {
        if (req != null && message != null) {
            req.getSession(true).setAttribute("FLASH_ERROR", message);
        }
    }

    public static void setFlashSuccess(HttpServletRequest req, String message) {
        if (req != null && message != null) {
            req.getSession(true).setAttribute("FLASH_SUCCESS", message);
        }
    }

    public static String popFlashError(HttpServletRequest req) {
        if (req == null) return null;
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        Object msg = session.getAttribute("FLASH_ERROR");
        if (msg != null) {
            session.removeAttribute("FLASH_ERROR");
            return msg.toString();
        }
        return null;
    }

    public static String popFlashSuccess(HttpServletRequest req) {
        if (req == null) return null;
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        Object msg = session.getAttribute("FLASH_SUCCESS");
        if (msg != null) {
            session.removeAttribute("FLASH_SUCCESS");
            return msg.toString();
        }
        return null;
    }
}
