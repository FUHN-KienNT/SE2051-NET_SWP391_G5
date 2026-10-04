package controller;

import dao.SettingDao;
import dao.UserDao;
import dto.LoginDto;
import dto.RegisterDto;
import dto.UserDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import service.AuthService;
import service.InactiveAccountException;
import util.SessionUtil;

@WebServlet(name = "AuthServlet", urlPatterns = { "/auth/*" })
public class AuthServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        UserDao userDao = new UserDao();
        SettingDao settingDao = new SettingDao();
        this.authService = new AuthService(userDao, settingDao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "login";
        processAction(action, req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "login";
        processAction(action, req, resp);
    }

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String method = req.getMethod();
        switch (action) {
            case "login":
                if ("POST".equalsIgnoreCase(method)) {
                    login(req, resp);
                } else {
                    showLogin(req, resp);
                }
                break;
            case "register":
                if ("POST".equalsIgnoreCase(method)) {
                    register(req, resp);
                } else {
                    showRegister(req, resp);
                }
                break;
            case "check-email":
                showCheckEmail(req, resp);
                break;
            case "logout":
                logout(req, resp);
                break;
            case "google-callback":
                googleCallback(req, resp);
                break;
            default:
                showLogin(req, resp);
                break;
        }
    }

    private void showLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            String flashToastType = (String) session.getAttribute("flashToastType");
            String flashToastMessage = (String) session.getAttribute("flashToastMessage");
            if (flashToastMessage != null) {
                req.setAttribute("toastType", flashToastType != null ? flashToastType : "info");
                req.setAttribute("toastMessage", flashToastMessage);
                session.removeAttribute("flashToastType");
                session.removeAttribute("flashToastMessage");
            }
        }

        // Whitelist check for status query param fallback
        String status = req.getParameter("status");
        if (req.getAttribute("toastMessage") == null && status != null) {
            if ("verified".equals(status)) {
                req.setAttribute("toastType", "success");
                req.setAttribute("toastMessage", "Xác thực tài khoản thành công! Hãy đăng nhập để bắt đầu học tập.");
            } else if ("already".equals(status)) {
                req.setAttribute("toastType", "info");
                req.setAttribute("toastMessage", "Tài khoản đã được xác thực trước đó, hãy đăng nhập.");
            } else if ("invalid".equals(status)) {
                req.setAttribute("toastType", "error");
                req.setAttribute("toastMessage",
                        "Liên kết xác thực không hợp lệ hoặc đã hết hạn. Bạn có thể yêu cầu gửi lại email xác nhận.");
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    private void showRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    private void showCheckEmail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/check-email.jsp").forward(req, resp);
    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String loginId = req.getParameter("loginId");
        String password = req.getParameter("password");
        boolean rememberMe = "on".equalsIgnoreCase(req.getParameter("rememberMe"));

        LoginDto dto = new LoginDto(loginId, password, rememberMe);
        try {
            UserDto user = authService.authenticate(dto);
            SessionUtil.setCurrentUser(req, user);
            redirectByRole(user, req, resp);
        } catch (InactiveAccountException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("inactiveEmail", e.getEmail());
            req.setAttribute("loginId", loginId);
            showLogin(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("loginId", loginId);
            showLogin(req, resp);
        }
    }

    private void register(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String fullName = req.getParameter("fullName");
        boolean agreeTerms = "on".equalsIgnoreCase(req.getParameter("agreeTerms"));

        RegisterDto dto = new RegisterDto(username, email, password, confirmPassword, fullName, agreeTerms);
        try {
            String scheme = req.getScheme();
            String serverName = req.getServerName();
            int serverPort = req.getServerPort();
            String contextPath = req.getContextPath();
            String dynamicBaseUrl = scheme + "://" + serverName
                    + ((serverPort == 80 || serverPort == 443) ? "" : (":" + serverPort)) + contextPath;

            authService.register(dto, dynamicBaseUrl);
            String encodedEmail = URLEncoder.encode(dto.getEmail().trim(), StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/auth/check-email?email=" + encodedEmail);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("registerDto", dto);
            showRegister(req, resp);
        }
    }

    private void logout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        authService.logout(req.getSession(false));
        resp.sendRedirect(req.getContextPath() + "/home");
    }

    private void googleCallback(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        String name = req.getParameter("name");
        try {
            UserDto user = authService.authenticateGoogle(email, name);
            SessionUtil.setCurrentUser(req, user);
            redirectByRole(user, req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/auth/login?error=" + e.getMessage());
        }
    }

    private void redirectByRole(UserDto user, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ctx = req.getContextPath();
        if (user == null || user.getRoleName() == null) {
            resp.sendRedirect(ctx + "/home");
            return;
        }

        String role = user.getRoleName();
        if ("ADMIN".equalsIgnoreCase(role) || "ROLE_ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(ctx + "/admin/dashboard");
        } else if ("EXPERT".equalsIgnoreCase(role) || "ROLE_EXPERT".equalsIgnoreCase(role)) {
            resp.sendRedirect(ctx + "/expert/dashboard");
        } else if ("MANAGER".equalsIgnoreCase(role) || "ROLE_MANAGER".equalsIgnoreCase(role)
                || "INSTRUCTOR".equalsIgnoreCase(role)) {
            resp.sendRedirect(ctx + "/admin/courses");
        } else {
            resp.sendRedirect(ctx + "/home");
        }
    }
}
