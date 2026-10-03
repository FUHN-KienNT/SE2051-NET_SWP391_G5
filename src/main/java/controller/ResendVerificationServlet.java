package controller;

import dao.UserDao;
import dao.VerificationTokenDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import service.EmailVerificationService;

@WebServlet(name = "ResendVerificationServlet", urlPatterns = {"/auth/resend-verification"})
public class ResendVerificationServlet extends HttpServlet {

    private EmailVerificationService emailVerificationService;

    @Override
    public void init() throws ServletException {
        this.emailVerificationService = new EmailVerificationService(new VerificationTokenDao(), new UserDao());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email != null && !email.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/auth/check-email?email=" + URLEncoder.encode(email.trim(), StandardCharsets.UTF_8));
        } else {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email != null) {
            email = email.trim();
        }

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))
                || (req.getHeader("Accept") != null && req.getHeader("Accept").contains("application/json"));

        String scheme = req.getScheme();
        String serverName = req.getServerName();
        int serverPort = req.getServerPort();
        String contextPath = req.getContextPath();
        String dynamicBaseUrl = scheme + "://" + serverName + ((serverPort == 80 || serverPort == 443) ? "" : (":" + serverPort)) + contextPath;

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

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
