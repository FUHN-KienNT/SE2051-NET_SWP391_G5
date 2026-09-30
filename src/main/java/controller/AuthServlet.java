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
import java.io.IOException;
import service.AuthService;
import util.SessionUtil;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth/*"})
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

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    private void showRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String loginId = req.getParameter("loginId");
        String password = req.getParameter("password");
        boolean rememberMe = "on".equalsIgnoreCase(req.getParameter("rememberMe"));

        LoginDto dto = new LoginDto(loginId, password, rememberMe);
        try {
            UserDto user = authService.authenticate(dto);
            SessionUtil.setCurrentUser(req, user);
            redirectByRole(req, user, resp);
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
            authService.register(dto);
            resp.sendRedirect(req.getContextPath() + "/auth/login?registered=true");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("registerDto", dto);
            showRegister(req, resp);
        }
    }

    private void logout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        authService.logout(req.getSession(false));
        resp.sendRedirect(req.getContextPath() + "/auth/login?logout=true");
    }

    private void googleCallback(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        String name = req.getParameter("name");
        try {
            UserDto user = authService.authenticateGoogle(email, name);
            SessionUtil.setCurrentUser(req, user);
            redirectByRole(req, user, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/auth/login?error=" + e.getMessage());
        }
    }

    private void redirectByRole(HttpServletRequest req, UserDto user, HttpServletResponse resp) throws IOException {
        String ctx = req.getContextPath();
        if (user != null && "ADMIN".equalsIgnoreCase(user.getRoleName())) {
            resp.sendRedirect(ctx + "/settings/list");
        } else if (user != null && ("INSTRUCTOR".equalsIgnoreCase(user.getRoleName()) || "MANAGER".equalsIgnoreCase(user.getRoleName()) || "EXPERT".equalsIgnoreCase(user.getRoleName()))) {
            resp.sendRedirect(ctx + "/courses/manage");
        } else {
            resp.sendRedirect(ctx + "/home");
        }
    }
}
