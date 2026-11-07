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
    "/registrations/course",
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
        processAction(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processAction(req, resp);
    }

    private void processAction(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        if (servletPath == null) {
            servletPath = "";
        }

        if (servletPath.endsWith("/detail")) {
            showRegistrationDetail(req, resp);
        } else if (servletPath.endsWith("/update-status")) {
            updateRegistrationStatus(req, resp);
        } else {
            showRegistrationList(req, resp);
        }
    }

    private void showRegistrationList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String courseIdStr = req.getParameter("courseId");
        String search = req.getParameter("search");
        String paymentStatus = req.getParameter("paymentStatus");
        String status = req.getParameter("status");

        List<RegistrationDto> rawList;
        CourseDto course = null;

        try {
            if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
                long courseId = Long.parseLong(courseIdStr.trim());
                if (!registrationService.canViewCourseRegistrations(courseId, currentUser)) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem danh sách đăng ký của khóa học này.");
                    return;
                }
                course = registrationService.getCourseSummary(courseId);
                rawList = registrationService.getByCourse(courseId);
            } else {
                if (!"MANAGER".equalsIgnoreCase(currentUser.getRoleName()) && !"ADMIN".equalsIgnoreCase(currentUser.getRoleName())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem danh sách đăng ký.");
                    return;
                }
                rawList = registrationService.getAll();
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã khóa học không hợp lệ.");
            return;
        }

        List<RegistrationDto> filteredList = new ArrayList<>();
        String searchTrim = (search != null) ? search.trim().toLowerCase() : null;
        for (RegistrationDto r : rawList) {
            if (searchTrim != null && !searchTrim.isEmpty()) {
                boolean matchId = String.valueOf(r.getId()).equals(searchTrim);
                boolean matchUser = r.getUserName() != null && r.getUserName().toLowerCase().contains(searchTrim);
                boolean matchCourse = r.getCourseTitle() != null && r.getCourseTitle().toLowerCase().contains(searchTrim);
                boolean matchCode = r.getPaymentCode() != null && r.getPaymentCode().toLowerCase().contains(searchTrim);
                if (!matchId && !matchUser && !matchCourse && !matchCode) {
                    continue;
                }
            }
            if (paymentStatus != null && !paymentStatus.trim().isEmpty()) {
                if (r.getPaymentStatus() == null || !r.getPaymentStatus().name().equalsIgnoreCase(paymentStatus.trim())) {
                    continue;
                }
            }
            if (status != null && !status.trim().isEmpty()) {
                if (r.getStatus() == null || !r.getStatus().name().equalsIgnoreCase(status.trim())) {
                    continue;
                }
            }
            filteredList.add(r);
        }

        req.setAttribute("course", course);
        req.setAttribute("registrations", filteredList);
        req.setAttribute("courseList", registrationService.getCoursesForManager(currentUser));
        req.getRequestDispatcher("/WEB-INF/views/registration/course.jsp").forward(req, resp);
    }

    private void showRegistrationDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
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
        String idStr = req.getParameter("id");
        String statusStr = req.getParameter("status");
        if (idStr != null && statusStr != null) {
            long regId = Long.parseLong(idStr);
            PaymentStatus pStatus = PaymentStatus.fromDb(statusStr);
            registrationService.updatePayment(regId, pStatus, "MANUAL-" + System.currentTimeMillis(),
                    OffsetDateTime.now());
        }
        resp.sendRedirect(req.getContextPath() + "/registrations/list");
    }
}

