package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.DevSeedService;
import util.SessionUtil;

import java.io.IOException;

@WebServlet(name = "DevSeedServlet", urlPatterns = {"/api/dev/reset-seed", "/dev/reset-seed"})
public class DevSeedServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processReset(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processReset(req, resp);
    }

    private void processReset(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        boolean success = DevSeedService.resetMasterSeed();

        String redirect = req.getParameter("redirect");
        if (redirect != null && !redirect.trim().isEmpty()) {
            if (success) {
                SessionUtil.setFlashSuccess(req, "Khôi phục toàn bộ CSDL kiểm thử thành công!");
            } else {
                SessionUtil.setFlashError(req, "Khôi phục dữ liệu thất bại. Vui lòng kiểm tra log hệ thống.");
            }
            resp.sendRedirect(req.getContextPath() + (redirect.startsWith("/") ? redirect : ("/" + redirect)));
            return;
        }

        String accept = req.getHeader("Accept");
        boolean isHtmlRequest = accept != null && accept.contains("text/html");

        if (isHtmlRequest) {
            resp.setContentType("text/html;charset=UTF-8");
            resp.getWriter().write("<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Reset Database Seed</title>"
                    + "<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css' rel='stylesheet'>"
                    + "<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css'>"
                    + "</head><body class='bg-light d-flex align-items-center min-vh-100 justify-content-center'>"
                    + "<div class='card shadow-lg p-5 rounded-4 text-center border-0' style='max-width: 520px;'>"
                    + (success 
                        ? "<div class='mb-3'><i class='bi bi-check-circle-fill text-success' style='font-size: 4rem;'></i></div>"
                          + "<h3 class='fw-bold text-dark'>Khôi phục CSDL thành công!</h3>"
                          + "<p class='text-muted mt-2'>Master Testing Seed (8 khóa học, 295 bài học thật, 5 tài khoản và trạng thái thanh toán) đã được nạp lại hoàn tất.</p>"
                        : "<div class='mb-3'><i class='bi bi-exclamation-triangle-fill text-danger' style='font-size: 4rem;'></i></div>"
                          + "<h3 class='fw-bold text-dark'>Khôi phục CSDL thất bại</h3>"
                          + "<p class='text-muted mt-2'>Không thể nạp dữ liệu seed. Vui lòng kiểm tra kết nối PostgreSQL.</p>")
                    + "<div class='d-flex justify-content-center gap-2 mt-4'>"
                    + "<a href='" + req.getContextPath() + "/home' class='btn btn-primary rounded-pill px-4 py-2 fw-semibold'>Về Trang chủ</a>"
                    + "<a href='" + req.getContextPath() + "/registrations/my' class='btn btn-outline-secondary rounded-pill px-4 py-2 fw-semibold'>Khóa học của tôi</a>"
                    + "</div>"
                    + "</div></body></html>");
            return;
        }

        resp.setContentType("application/json;charset=UTF-8");
        if (success) {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("{"
                    + "\"success\":true,"
                    + "\"message\":\"Khôi phục toàn bộ CSDL kiểm thử thành công! Mọi trạng thái khóa học, tài khoản & thanh toán đã sẵn sàng.\","
                    + "\"timestamp\":\"" + java.time.OffsetDateTime.now() + "\""
                    + "}");
        } else {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{"
                    + "\"success\":false,"
                    + "\"message\":\"Khôi phục dữ liệu thất bại. Vui lòng kiểm tra log hệ thống.\""
                    + "}");
        }
    }
}
