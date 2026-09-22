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
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import util.SessionUtil;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {"/*"})
public class AuthorizationFilter implements Filter {
    private Map<String, Set<String>> routeRoles = new HashMap<>();

    @Override
    public void init(FilterConfig config) throws ServletException {
        // Settings are for ADMIN
        routeRoles.put("/settings", new HashSet<>(Arrays.asList("ADMIN", "ROLE_ADMIN")));
        // Users management is for ADMIN
        routeRoles.put("/users", new HashSet<>(Arrays.asList("ADMIN", "ROLE_ADMIN")));
        // Course management (edit/create/delete) is for INSTRUCTOR / MANAGER / EXPERT / ADMIN
        routeRoles.put("/courses/manage", new HashSet<>(Arrays.asList(
                "ADMIN", "ROLE_ADMIN", "MANAGER", "ROLE_MANAGER", "EXPERT", "ROLE_EXPERT", "INSTRUCTOR", "ROLE_INSTRUCTOR"
        )));
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
            sendForbidden(resp);
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

    private void sendForbidden(HttpServletResponse resp) throws IOException {
        resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to access this resource.");
    }
}
