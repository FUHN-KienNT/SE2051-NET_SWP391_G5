package filter;

import dto.UserDto;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import util.SessionUtil;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {"/*"})
public class AuthorizationFilter implements Filter {
    private Map<String, Set<String>> routeRoles = new LinkedHashMap<>();

    @Override
    public void init(FilterConfig config) throws ServletException {
        Set<String> managerOrAdmin = new HashSet<>(Arrays.asList("ADMIN", "ROLE_ADMIN", "MANAGER", "ROLE_MANAGER"));
        // Registration administration is restricted to Manager and Admin.
        routeRoles.put("/registrations/list", managerOrAdmin);
        // routeRoles.put("/registrations/detail", managerOrAdmin); // Dynamically handled: Student -> my-detail, Manager -> admin detail
        routeRoles.put("/registrations/update-status", managerOrAdmin);
        // Settings are for ADMIN
        routeRoles.put("/settings", new HashSet<>(Arrays.asList("ADMIN", "ROLE_ADMIN")));
        // Users management is for ADMIN
        routeRoles.put("/users", new HashSet<>(Arrays.asList("ADMIN", "ROLE_ADMIN")));
        // Admin workspace (Admin Dashboard & Course Management) is for ADMIN & MANAGER
        routeRoles.put("/admin", managerOrAdmin);
        routeRoles.put("/manager", managerOrAdmin);
        // Expert workspace (Expert Dashboard & Lesson Management) is for EXPERT only
        routeRoles.put("/expert", new HashSet<>(Arrays.asList("EXPERT", "ROLE_EXPERT")));

        // Quiz administration is restricted to Staff (Admin, Manager) and Expert
        Set<String> staffOrExpert = new HashSet<>(Arrays.asList("ADMIN", "ROLE_ADMIN", "MANAGER", "ROLE_MANAGER", "EXPERT", "ROLE_EXPERT"));
        routeRoles.put("/quizzes/list", staffOrExpert);
        routeRoles.put("/quizzes/questions", staffOrExpert);
        routeRoles.put("/quizzes/detail", staffOrExpert);
        routeRoles.put("/quizzes/save", staffOrExpert);
        routeRoles.put("/quizzes/delete", staffOrExpert);
        routeRoles.put("/quizzes/toggle-active", staffOrExpert);
        routeRoles.put("/quizzes/save-question", staffOrExpert);
        routeRoles.put("/quizzes/delete-question", staffOrExpert);
        routeRoles.put("/quizzes/assign-question", staffOrExpert);
        routeRoles.put("/quizzes/remove-question", staffOrExpert);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getServletPath();
        String pathInfo = req.getPathInfo();
        String fullPath = path + (pathInfo != null ? pathInfo : "");

        Set<String> required = requiredRoles(fullPath);
        if (required.isEmpty()) {
            chain.doFilter(request, response);
            return;
        }

        UserDto currentUser = SessionUtil.getCurrentUser(req);
        String role = (currentUser != null) ? currentUser.getRoleName() : null;

        if (hasPermission(role, required)) {
            chain.doFilter(request, response);
        } else {
            if ("ADMIN".equalsIgnoreCase(role) || "ROLE_ADMIN".equalsIgnoreCase(role)) {
                String msg = "Tài khoản Quản trị viên không thuộc phạm vi Expert Studio. Hệ thống đã chuyển hướng bạn về Admin Dashboard.";
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?error="
                        + java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8));
                return;
            }
            if ("MANAGER".equalsIgnoreCase(role) || "ROLE_MANAGER".equalsIgnoreCase(role)) {
                String msg = "Tài khoản Quản lý không thuộc phạm vi Expert Studio. Hệ thống đã chuyển hướng bạn về Manager Dashboard.";
                resp.sendRedirect(req.getContextPath() + "/manager/dashboard?error="
                        + java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8));
                return;
            }
            if ("EXPERT".equalsIgnoreCase(role) || "ROLE_EXPERT".equalsIgnoreCase(role)) {
                String msg = "Tài khoản Chuyên gia không có quyền truy cập vào khu vực này. Hệ thống đã chuyển hướng bạn về Expert Dashboard.";
                resp.sendRedirect(req.getContextPath() + "/expert/dashboard?error="
                        + java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8));
                return;
            }
            sendForbidden(req, resp);
        }
    }

    @Override
    public void destroy() {
    }

    private Set<String> requiredRoles(String path) {
        if (path == null) return new HashSet<>();
        for (Map.Entry<String, Set<String>> entry : routeRoles.entrySet()) {
            if (path.startsWith(entry.getKey())) {
                return entry.getValue();
            }
        }
        return new HashSet<>();
    }

    private boolean hasPermission(String role, Set<String> required) {
        if (role == null || required == null) {
            return false;
        }
        for (String r : required) {
            if (r.equalsIgnoreCase(role)) {
                return true;
            }
        }
        return false;
    }

    private void sendForbidden(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String msg = "Bạn không có quyền truy cập vào chức năng này.";
        resp.sendRedirect(req.getContextPath() + "/home?error="
                + java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8));
    }
}
