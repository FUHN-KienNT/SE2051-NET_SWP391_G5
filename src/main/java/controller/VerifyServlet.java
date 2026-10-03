package controller;

import dao.UserDao;
import dao.VerificationTokenDao;
import entity.enums.VerifyResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import service.EmailVerificationService;

@WebServlet(name = "VerifyServlet", urlPatterns = {"/verify"})
public class VerifyServlet extends HttpServlet {

    private EmailVerificationService emailVerificationService;

    @Override
    public void init() throws ServletException {
        this.emailVerificationService = new EmailVerificationService(new VerificationTokenDao(), new UserDao());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
}
