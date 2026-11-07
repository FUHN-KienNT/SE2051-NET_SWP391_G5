package controller;

import dao.PasswordResetTokenDao;
import dao.SettingDao;
import dao.UserDao;
import dao.VerificationTokenDao;
import dto.GoogleAuthResult;
import dto.LoginDto;
import dto.RegisterDto;
import dto.UserDto;
import entity.enums.VerifyResult;
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
import service.EmailVerificationService;
import service.InactiveAccountException;
import service.PasswordResetService;
import service.ValidationException;
import util.GoogleOAuthUtil;
import util.SessionUtil;
import util.WebUtil;

@WebServlet(name = "AuthServlet", urlPatterns = { "/auth/*", "/verify" })
public class AuthServlet extends HttpServlet {

    private AuthService authService;
    private EmailVerificationService emailVerificationService;
    private PasswordResetService passwordResetService;

    @Override
    public void init() throws ServletException {
        UserDao userDao = new UserDao();
        SettingDao settingDao = new SettingDao();
        VerificationTokenDao verificationTokenDao = new VerificationTokenDao();
        this.authService = new AuthService(userDao, settingDao);
        this.emailVerificationService = new EmailVerificationService(verificationTokenDao, userDao);
        this.passwordResetService = new PasswordResetService(userDao, new PasswordResetTokenDao());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processAction(resolveAction(req), req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processAction(resolveAction(req), req, resp);
    }

    private String resolveAction(HttpServletRequest req) {
        if ("/verify".equalsIgnoreCase(req.getServletPath())) {
            return "verify";
        }
        String pathInfo = req.getPathInfo();
        return pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "login";
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
            case "verify":
                handleVerifyEmail(req, resp);
                break;
            case "resend-verification":
                handleResendVerification(req, resp);
                break;
            case "logout":
                logout(req, resp);
                break;
            case "google":
                // Bước 1: Redirect người dùng tới Google để xác thực
                initiateGoogleLogin(req, resp);
                break;
            case "google-callback":
                // Bước 2: Google redirect về đây với ?code=... sau khi người dùng đồng ý
                googleCallback(req, resp);
                break;
            case "set-password":
                if ("POST".equalsIgnoreCase(method)) {
                    setPassword(req, resp);
                } else {
                    showSetPassword(req, resp);
                }
                break;
            case "forgot-password":
                if ("POST".equalsIgnoreCase(method)) {
                    handleForgotPassword(req, resp);
                } else {
                    showForgotPassword(req, resp);
                }
                break;
            case "forgot-password-check-email":
                showForgotPasswordCheckEmail(req, resp);
                break;
            case "resend-forgot-password":
                handleResendForgotPassword(req, resp);
                break;
            case "reset-password":
                if ("POST".equalsIgnoreCase(method)) {
                    handleResetPassword(req, resp);
                } else {
                    showResetPassword(req, resp);
                }
                break;
            default:
                showLogin(req, resp);
                break;
        }
    }

    private void showLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser != null) {
            redirectByRole(currentUser, req, resp);
            return;
        }

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
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser != null) {
            redirectByRole(currentUser, req, resp);
            return;
        }
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

            HttpSession session = req.getSession(true);
            session.setAttribute("flashToastType", "success");
            session.setAttribute("flashToastMessage", "Đăng nhập thành công! Chào mừng bạn quay trở lại.");

            redirectByRole(user, req, resp);
        } catch (ValidationException e) {
            req.setAttribute("fieldErrors", e.getErrors());
            req.setAttribute("loginId", loginId);
            showLogin(req, resp);
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

    private String getDynamicBaseUrl(HttpServletRequest req) {
        return WebUtil.getDynamicBaseUrl(req);
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
            String dynamicBaseUrl = getDynamicBaseUrl(req);

            authService.register(dto, dynamicBaseUrl);
            String encodedEmail = URLEncoder.encode(dto.getEmail().trim(), StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/auth/check-email?email=" + encodedEmail);
        } catch (ValidationException e) {
            req.setAttribute("fieldErrors", e.getErrors());
            req.setAttribute("registerDto", dto);
            showRegister(req, resp);
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

    /**
     * Bước 1 – Redirect trình duyệt người dùng tới Google OAuth consent screen.
     * Sinh CSRF state token, lưu vào session để xác thực ở callback.
     */
    private void initiateGoogleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!GoogleOAuthUtil.isConfigured()) {
            // Credentials chưa được điền → hiển thị trang login với thông báo lỗi
            HttpSession session = req.getSession(true);
            session.setAttribute("flashToastType", "error");
            session.setAttribute("flashToastMessage",
                "Chức năng đăng nhập Google chưa được cấu hình. Vui lòng liên hệ quản trị viên.");
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // Tạo CSRF state token để chống CSRF attack
        String state = java.util.UUID.randomUUID().toString();
        HttpSession session = req.getSession(true);
        session.setAttribute("oauth_state", state);

        try {
            String authUrl = GoogleOAuthUtil.buildAuthUrl(state);
            resp.sendRedirect(authUrl);
        } catch (IOException e) {
            session.setAttribute("flashToastType", "error");
            session.setAttribute("flashToastMessage", "Không thể kết nối tới Google. Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }

    /**
     * Bước 2 – Google redirect về đây sau khi người dùng đồng ý (hoặc từ chối).
     * Xử lý: xác thực state, đổi code lấy token, lấy user info, đăng nhập/tạo account.
     */
    private void googleCallback(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        String ctx = req.getContextPath();

        // ── Kiểm tra người dùng từ chối đăng nhập Google ──
        String error = req.getParameter("error");
        if (error != null) {
            if (session != null) {
                session.setAttribute("flashToastType", "info");
                session.setAttribute("flashToastMessage", "Bạn đã huỷ đăng nhập bằng Google.");
            }
            resp.sendRedirect(ctx + "/auth/login");
            return;
        }

        // ── Xác thực CSRF state ──
        String returnedState = req.getParameter("state");
        String savedState = (session != null) ? (String) session.getAttribute("oauth_state") : null;
        if (savedState == null || !savedState.equals(returnedState)) {
            if (session != null) {
                session.setAttribute("flashToastType", "error");
                session.setAttribute("flashToastMessage", "Phiên đăng nhập không hợp lệ. Vui lòng thử lại.");
            }
            resp.sendRedirect(ctx + "/auth/login");
            return;
        }
        // Xoá state đã dùng
        if (session != null) {
            session.removeAttribute("oauth_state");
        }

        // ── Lấy authorization code từ Google ──
        String code = req.getParameter("code");
        if (code == null || code.isBlank()) {
            if (session == null) session = req.getSession(true);
            session.setAttribute("flashToastType", "error");
            session.setAttribute("flashToastMessage", "Không nhận được mã xác thực từ Google.");
            resp.sendRedirect(ctx + "/auth/login");
            return;
        }

        try {
            // ── Bước 2a: Đổi code → access token ──
            String accessToken = GoogleOAuthUtil.exchangeCodeForToken(code);

            // ── Bước 2b: Lấy thông tin người dùng từ Google ──
            GoogleOAuthUtil.GoogleUserInfo googleUser = GoogleOAuthUtil.getUserInfo(accessToken);

            if (googleUser.getEmail() == null || googleUser.getEmail().isBlank()) {
                throw new IllegalArgumentException("Không lấy được email từ tài khoản Google.");
            }
            if (!googleUser.isEmailVerified()) {
                throw new IllegalArgumentException("Địa chỉ email Google của bạn chưa được xác minh.");
            }

            // ── Bước 2c: Đăng nhập hoặc tạo tài khoản ──
            String dynamicBaseUrl = getDynamicBaseUrl(req);
            GoogleAuthResult result = authService.authenticateGoogle(googleUser.getEmail(), googleUser.getName(), dynamicBaseUrl);
            UserDto user = result.getUser();

            if (session == null) session = req.getSession(true);
            if (!result.hasPassword()) {
                session.setAttribute("PENDING_SET_PASSWORD_USER", user);
                session.setAttribute("flashToastType", "success");
                session.setAttribute("flashToastMessage",
                    "Đăng nhập bằng Google thành công! Bạn có thể sử dụng tài khoản Gmail này để đăng nhập các lần sau.");
                resp.sendRedirect(ctx + "/auth/set-password");
                return;
            }

            SessionUtil.setCurrentUser(req, user);

            if (result.getStatus() == GoogleAuthResult.Status.UNVERIFIED_ACTIVATED) {
                session.setAttribute("flashToastType", "success");
                session.setAttribute("flashToastMessage",
                    "Đăng nhập Google thành công! Tài khoản của bạn đã được kích hoạt.");
                redirectByRole(user, req, resp);
            } else {
                session.setAttribute("flashToastType", "success");
                session.setAttribute("flashToastMessage", "Đăng nhập bằng Google thành công! Chào mừng bạn quay trở lại.");
                redirectByRole(user, req, resp);
            }

        } catch (Exception e) {
            String msg = e.getMessage();
            if (msg == null || msg.isBlank()) msg = "Đăng nhập bằng Google thất bại. Vui lòng thử lại.";
            if (session == null) session = req.getSession(true);
            session.setAttribute("flashToastType", "error");
            session.setAttribute("flashToastMessage", msg);
            resp.sendRedirect(ctx + "/auth/login");
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
        } else if ("MANAGER".equalsIgnoreCase(role) || "ROLE_MANAGER".equalsIgnoreCase(role)) {
            resp.sendRedirect(ctx + "/manager/dashboard");
        } else if ("INSTRUCTOR".equalsIgnoreCase(role)) {
            resp.sendRedirect(ctx + "/admin/courses");
        } else {
            // Mặc định đối với vai trò Student (Học viên) chuyển thẳng đến Student Dashboard (/registrations/my)
            resp.sendRedirect(ctx + "/registrations/my");
        }
    }
    private void showSetPassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserDto pendingUser = (session != null) ? (UserDto) session.getAttribute("PENDING_SET_PASSWORD_USER") : null;
        if (pendingUser == null) {
            UserDto currentUser = SessionUtil.getCurrentUser(req);
            if (currentUser != null && !authService.hasPassword(currentUser.getId())) {
                pendingUser = currentUser;
            }
        }

        if (pendingUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        req.setAttribute("user", pendingUser);
        req.getRequestDispatcher("/WEB-INF/views/auth/set-password.jsp").forward(req, resp);
    }

    private void setPassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserDto pendingUser = (session != null) ? (UserDto) session.getAttribute("PENDING_SET_PASSWORD_USER") : null;
        if (pendingUser == null) {
            UserDto currentUser = SessionUtil.getCurrentUser(req);
            if (currentUser != null && !authService.hasPassword(currentUser.getId())) {
                pendingUser = currentUser;
            }
        }

        if (pendingUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        try {
            authService.setPassword(pendingUser.getId(), password, confirmPassword);
            if (session == null) session = req.getSession(true);
            session.removeAttribute("PENDING_SET_PASSWORD_USER");
            SessionUtil.setCurrentUser(req, pendingUser);

            session.setAttribute("flashToastType", "success");
            session.setAttribute("flashToastMessage", "Thiết lập mật khẩu thành công! Chào mừng bạn đến với Courson LMS.");
            redirectByRole(pendingUser, req, resp);
        } catch (ValidationException e) {
            req.setAttribute("fieldErrors", e.getErrors());
            req.setAttribute("user", pendingUser);
            req.getRequestDispatcher("/WEB-INF/views/auth/set-password.jsp").forward(req, resp);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("user", pendingUser);
            req.getRequestDispatcher("/WEB-INF/views/auth/set-password.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Không thể thiết lập mật khẩu: " + e.getMessage());
            req.setAttribute("user", pendingUser);
            req.getRequestDispatcher("/WEB-INF/views/auth/set-password.jsp").forward(req, resp);
        }
    }

    private void showForgotPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(req, resp);
    }

    private void handleForgotPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String dynamicBaseUrl = WebUtil.getDynamicBaseUrl(req);

        try {
            passwordResetService.sendResetRequest(email, dynamicBaseUrl);
            String devResetUrl = passwordResetService.getLastResetUrl(email);
            if (devResetUrl != null) {
                req.getSession().setAttribute("devResetUrl", devResetUrl);
            }
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password-check-email?email="
                    + (email != null ? URLEncoder.encode(email.trim(), StandardCharsets.UTF_8) : ""));
        } catch (ValidationException e) {
            req.setAttribute("fieldErrors", e.getErrors());
            req.setAttribute("email", email != null ? email.trim() : "");
            req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(req, resp);
        } catch (IllegalArgumentException | IllegalStateException e) {
            req.setAttribute("errorMessage", e.getMessage());
            req.setAttribute("email", email != null ? email.trim() : "");
            req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMessage", "Có lỗi xảy ra trong quá trình xử lý yêu cầu. Vui lòng thử lại sau.");
            req.setAttribute("email", email != null ? email.trim() : "");
            req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(req, resp);
        }
    }

    private void showForgotPasswordCheckEmail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password");
            return;
        }
        req.setAttribute("email", email.trim());
        req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password-check-email.jsp").forward(req, resp);
    }

    private void handleResendForgotPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email != null) {
            email = email.trim();
        }

        boolean isAjax = WebUtil.isAjax(req);
        String dynamicBaseUrl = WebUtil.getDynamicBaseUrl(req);

        try {
            passwordResetService.resendResetRequest(email, dynamicBaseUrl);
            String devResetUrl = passwordResetService.getLastResetUrl(email);
            if (devResetUrl != null) {
                req.getSession().setAttribute("devResetUrl", devResetUrl);
            }

            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"success\":true,\"message\":\"Email xác thực mới đã được gửi đi! Vui lòng kiểm tra hộp thư của bạn.\"}");
                resp.getWriter().flush();
            } else {
                resp.sendRedirect(req.getContextPath() + "/auth/forgot-password-check-email?email="
                        + (email != null ? URLEncoder.encode(email, StandardCharsets.UTF_8) : "")
                        + "&resent=true");
            }
        } catch (IllegalStateException rateLimitEx) {
            if (isAjax) {
                resp.setStatus(429);
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"success\":false,\"rateLimited\":true,\"message\":\"" + escapeJson(rateLimitEx.getMessage()) + "\"}");
                resp.getWriter().flush();
            } else {
                resp.sendRedirect(req.getContextPath() + "/auth/forgot-password-check-email?email="
                        + (email != null ? URLEncoder.encode(email, StandardCharsets.UTF_8) : "")
                        + "&error=ratelimit");
            }
        } catch (Exception ex) {
            if (isAjax) {
                resp.setStatus(500);
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"success\":false,\"message\":\"Có lỗi xảy ra khi gửi lại email. Vui lòng thử lại sau.\"}");
                resp.getWriter().flush();
            } else {
                resp.sendRedirect(req.getContextPath() + "/auth/forgot-password-check-email?email="
                        + (email != null ? URLEncoder.encode(email, StandardCharsets.UTF_8) : "")
                        + "&error=system");
            }
        }
    }

    private String escapeJson(String text) {
        return WebUtil.escapeJson(text);
    }

    private void showResetPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            req.setAttribute("invalidToken", true);
            req.setAttribute("errorMessage", "Liên kết đặt lại mật khẩu không hợp lệ hoặc thiếu mã xác thực.");
            req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
            return;
        }

        try {
            passwordResetService.validateToken(token.trim());
            req.setAttribute("token", token.trim());
            req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
        } catch (IllegalArgumentException e) {
            req.setAttribute("invalidToken", true);
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("invalidToken", true);
            req.setAttribute("errorMessage", "Có lỗi hệ thống khi kiểm tra liên kết đặt lại mật khẩu.");
            req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
        }
    }

    private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        try {
            passwordResetService.resetPassword(token, password, confirmPassword);
            SessionUtil.invalidate(req);
            HttpSession session = req.getSession(true);
            session.setAttribute("flashToastType", "success");
            session.setAttribute("flashToastMessage", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập bằng mật khẩu mới.");
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        } catch (ValidationException e) {
            req.setAttribute("token", token != null ? token.trim() : "");
            req.setAttribute("fieldErrors", e.getErrors());
            req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
        } catch (IllegalArgumentException e) {
            req.setAttribute("token", token != null ? token.trim() : "");
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("token", token != null ? token.trim() : "");
            req.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật mật khẩu: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
        }
    }

    private void handleVerifyEmail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String token = req.getParameter("token");
        VerifyResult result = emailVerificationService.verifyEmail(token);

        HttpSession session = req.getSession(true);
        String targetStatus;

        switch (result) {
            case SUCCESS:
                session.setAttribute("flashToastType", "success");
                session.setAttribute("flashToastMessage", "Xác thực tài khoản thành công! Hãy đăng nhập để bắt đầu học tập.");
                targetStatus = "verified";
                break;
            case ALREADY_VERIFIED:
                session.setAttribute("flashToastType", "info");
                session.setAttribute("flashToastMessage", "Tài khoản đã được xác thực trước đó, hãy đăng nhập.");
                targetStatus = "already";
                break;
            case INVALID_OR_EXPIRED:
            default:
                session.setAttribute("flashToastType", "error");
                session.setAttribute("flashToastMessage", "Liên kết xác thực không hợp lệ hoặc đã hết hạn. Bạn có thể yêu cầu gửi lại email xác nhận.");
                targetStatus = "invalid";
                break;
        }

        resp.sendRedirect(req.getContextPath() + "/auth/login?status=" + targetStatus);
    }

    private void handleResendVerification(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        if (email != null) {
            email = email.trim();
        }

        if ("GET".equalsIgnoreCase(req.getMethod()) && (email == null || email.isEmpty())) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        boolean isAjax = WebUtil.isAjax(req);
        String dynamicBaseUrl = WebUtil.getDynamicBaseUrl(req);

        try {
            emailVerificationService.resendVerification(email, dynamicBaseUrl);

            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"success\":true,\"message\":\"Email xác thực mới đã được gửi đi.\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/auth/check-email?email="
                        + (email != null ? URLEncoder.encode(email, StandardCharsets.UTF_8) : "")
                        + "&resent=true");
            }
        } catch (IllegalStateException rateLimitEx) {
            if (isAjax) {
                resp.setStatus(429);
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"success\":false,\"rateLimited\":true,\"message\":\"" + escapeJson(rateLimitEx.getMessage()) + "\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/auth/check-email?email="
                        + (email != null ? URLEncoder.encode(email, StandardCharsets.UTF_8) : "")
                        + "&error=ratelimit");
            }
        } catch (Exception ex) {
            if (isAjax) {
                resp.setStatus(500);
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"success\":false,\"message\":\"Có lỗi xảy ra khi gửi lại email. Vui lòng thử lại sau.\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/auth/check-email?email="
                        + (email != null ? URLEncoder.encode(email, StandardCharsets.UTF_8) : "")
                        + "&error=system");
            }
        }
    }
}
