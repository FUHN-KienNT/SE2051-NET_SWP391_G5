package controller;

import dao.CourseDao;
import dao.RegistrationDao;
import dto.CourseDto;
import dto.RegistrationDto;
import dto.UserDto;
import entity.enums.PaymentStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import service.RegistrationService;
import util.SessionUtil;

/**
 * Controller phục vụ phân hệ Quản lý Đăng ký (Registration Management)
 * Dành cho Quản lý (Manager) và Quản trị viên (Admin):
 * - Danh sách đơn đăng ký (Registration List)
 * - Chi tiết đơn đăng ký (Registration Detail)
 * - Cập nhật trạng thái đơn đăng ký (Update Registration Status)
 */
@WebServlet(name = "RegistrationManagementServlet", urlPatterns = {
    "/registrations/list",
    "/registrations/detail",
    "/registrations/update-status"
})
public class RegistrationManagementServlet extends HttpServlet {
    private RegistrationService registrationService;

    @Override
    public void init() throws ServletException {
        this.registrationService = new RegistrationService(new RegistrationDao(), new CourseDao());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath() != null ? req.getServletPath() : "";
        if (servletPath.endsWith("/update-status")) {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Phương thức GET không được hỗ trợ cho thao tác này.");
            return;
        }
        if (servletPath.endsWith("/detail")) {
            showRegistrationDetail(req, resp);
        } else {
            showRegistrationList(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath() != null ? req.getServletPath() : "";
        if (servletPath.endsWith("/update-status")) {
            updateRegistrationStatus(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Phương thức POST không được hỗ trợ cho thao tác này.");
        }
    }

    private void showRegistrationList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        if (!"MANAGER".equalsIgnoreCase(currentUser.getRoleName()) && !"ADMIN".equalsIgnoreCase(currentUser.getRoleName())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem danh sách đăng ký.");
            return;
        }

        String courseIdStr = req.getParameter("courseId");
        String search = req.getParameter("search");
        String paymentStatus = req.getParameter("paymentStatus");
        String status = req.getParameter("status");

        Long courseId = null;
        CourseDto course = null;

        if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
            try {
                courseId = Long.parseLong(courseIdStr.trim());
                if (!registrationService.canViewCourseRegistrations(courseId, currentUser)) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem danh sách đăng ký của khóa học này.");
                    return;
                }
                course = registrationService.getCourseSummary(courseId);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã khóa học không hợp lệ.");
                return;
            }
        }

        // 1 lần tìm kiếm = 1 lần query xuống Database (Server-side search, Manager chỉ xem các đơn thuộc khóa học mình phụ trách)
        Long managerId = "MANAGER".equalsIgnoreCase(currentUser.getRoleName()) ? currentUser.getId() : null;
        List<RegistrationDto> list = registrationService.searchRegistrations(courseId, managerId, search, paymentStatus, status);

        req.setAttribute("course", course);
        req.setAttribute("registrations", list);
        req.setAttribute("courseList", registrationService.getCoursesForManager(currentUser));
        req.getRequestDispatcher("/WEB-INF/views/registration/list.jsp").forward(req, resp);
    }

    private void showRegistrationDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        if (!"MANAGER".equalsIgnoreCase(currentUser.getRoleName()) && !"ADMIN".equalsIgnoreCase(currentUser.getRoleName())) {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/registrations/my-detail?id=" + idStr.trim());
                return;
            }
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem chi tiết đơn đăng ký.");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã đăng ký.");
            return;
        }
        try {
            RegistrationDto registration = registrationService.getById(Long.parseLong(idStr));
            if (registration == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đăng ký.");
                return;
            }
            if (!registrationService.canViewRegistration(registration, currentUser)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem đăng ký này.");
                return;
            }
            req.setAttribute("registration", registration);
            req.getRequestDispatcher("/WEB-INF/views/registration/detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đăng ký không hợp lệ.");
        }
    }

    private void updateRegistrationStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        if (!"MANAGER".equalsIgnoreCase(currentUser.getRoleName()) && !"ADMIN".equalsIgnoreCase(currentUser.getRoleName())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện thao tác này.");
            return;
        }

        String idStr = req.getParameter("id");
        String statusStr = req.getParameter("status");
        if (idStr == null || statusStr == null) {
            resp.sendRedirect(req.getContextPath() + "/registrations/list?error="
                    + java.net.URLEncoder.encode("Thiếu thông tin đơn đăng ký hoặc trạng thái.", java.nio.charset.StandardCharsets.UTF_8));
            return;
        }

        try {
            long regId = Long.parseLong(idStr.trim());
            RegistrationDto registration = registrationService.getById(regId);
            if (registration == null) {
                resp.sendRedirect(req.getContextPath() + "/registrations/list?error="
                        + java.net.URLEncoder.encode("Không tìm thấy đơn đăng ký #" + regId, java.nio.charset.StandardCharsets.UTF_8));
                return;
            }

            if (!registrationService.canViewRegistration(registration, currentUser)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền quản lý đơn đăng ký của khóa học này.");
                return;
            }

            PaymentStatus pStatus = PaymentStatus.fromDb(statusStr.trim());
            registrationService.updatePayment(regId, pStatus, "MANUAL-" + System.currentTimeMillis(), OffsetDateTime.now());
            resp.sendRedirect(req.getContextPath() + "/registrations/detail?id=" + regId + "&success=status_updated");
        } catch (IllegalArgumentException | IllegalStateException e) {
            resp.sendRedirect(req.getContextPath() + "/registrations/list?error="
                    + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi cập nhật trạng thái.", java.nio.charset.StandardCharsets.UTF_8));
        }
    }
}

