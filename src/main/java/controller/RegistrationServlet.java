package controller;

import dao.CourseDao;
import dao.LessonDao;
import dao.LessonProgressDao;
import dao.ModuleDao;
import dao.RegistrationDao;
import entity.Course;
import dto.CourseDto;
import dto.RecentLearningDto;
import dto.RegistrationDto;
import dto.UserDto;
import entity.enums.PaymentStatus;
import entity.enums.RegistrationStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import service.CourseService;
import service.RegistrationService;
import service.VnPayService;
import service.VnPayService.VnPayReturnOutcome;
import util.SessionUtil;
import util.VnPayUtil;

@WebServlet(name = "RegistrationServlet", urlPatterns = { "/registrations/*" })
public class RegistrationServlet extends HttpServlet {
    private RegistrationService registrationService;
    private VnPayService vnPayService;
    private CourseService courseService;

    @Override
    public void init() throws ServletException {
        CourseDao cDao = new CourseDao();
        RegistrationDao rDao = new RegistrationDao();
        this.registrationService = new RegistrationService(rDao, cDao);
        this.vnPayService = new VnPayService(this.registrationService);
        this.courseService = new CourseService(cDao, new ModuleDao(), new LessonDao(), new LessonProgressDao(), rDao);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "my";
        processAction(action, req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        String action = pathInfo != null && pathInfo.length() > 1 ? pathInfo.substring(1) : "my";
        processAction(action, req, resp);
    }

    private void processAction(String action, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        switch (action) {
            case "checkout":
                if ("POST".equalsIgnoreCase(req.getMethod())) {
                    processCheckout(req, resp);
                } else {
                    showCheckout(req, resp);
                }
                break;
            case "payment":
                showPayment(req, resp);
                break;
            case "vnpay-create":
            case "pay-vnpay":
                createVnPayPayment(req, resp);
                break;

            case "my":
            case "my-courses":
                showMyRegistrations(req, resp);
                break;
            case "course":
            case "list":
                showCourseRegistrations(req, resp);
                break;
            case "detail":
                showRegistrationDetail(req, resp);
                break;
            case "enroll":
                String enrollCourseId = req.getParameter("courseId");
                if (enrollCourseId != null && !enrollCourseId.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/registrations/checkout?courseId=" + enrollCourseId.trim());
                } else {
                    resp.sendRedirect(req.getContextPath() + "/courses/catalog");
                }
                break;
            case "cancel":
                cancel(req, resp);
                break;
            case "vnpay-return":
            case "payment-return":
                paymentReturn(req, resp);
                break;
            case "vnpay-ipn":
            case "payment-callback":
                paymentCallback(req, resp);
                break;
            case "update-status":
                updateRegistrationStatus(req, resp);
                break;
            default:
                showMyRegistrations(req, resp);
                break;
        }
    }

    // =========================================================================
    // PARAMETER RESOLUTION & HELPER METHODS (Item 1 & Item 2 Optimization)
    // =========================================================================

    /**
     * Hợp nhất xử lý tham số khóa học từ request (Item 1):
     * Nhận diện courseId trực tiếp hoặc phân giải gián tiếp từ registrationId / id.
     */
    private Long resolveCourseId(HttpServletRequest req) {
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
            try {
                return Long.parseLong(courseIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }
        String regIdStr = req.getParameter("id");
        if (regIdStr == null || regIdStr.trim().isEmpty()) {
            regIdStr = req.getParameter("registrationId");
        }
        if (regIdStr != null && !regIdStr.trim().isEmpty()) {
            try {
                long regId = Long.parseLong(regIdStr.trim());
                RegistrationDto reg = registrationService.getById(regId);
                if (reg != null) {
                    return reg.getCourseId();
                }
            } catch (Exception ignored) {}
        }
        return null;
    }

    /**
     * Nạp Course hợp lệ và xử lý redirect thống nhất giữa Checkout và Payment
     */
    private Course getValidCourseOrRedirect(HttpServletRequest req, HttpServletResponse resp, Long courseId,
                                            UserDto currentUser, boolean checkAlreadyOwned) throws IOException {
        if (courseId == null) {
            SessionUtil.setFlashError(req, "Vui lòng chọn khóa học.");
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return null;
        }
        if (checkAlreadyOwned && registrationService.hasCourseAccess(currentUser.getId(), courseId)) {
            SessionUtil.setFlashSuccess(req, "Bạn đã đăng ký và sở hữu khóa học này rồi!");
            resp.sendRedirect(req.getContextPath() + "/courses/detail?id=" + courseId);
            return null;
        }
        Course course = null;
        try (java.sql.Connection con = util.DbConnection.getConnection()) {
            course = new CourseDao().findById(con, courseId).orElse(null);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (course == null) {
            SessionUtil.setFlashError(req, "Không tìm thấy khóa học yêu cầu hoặc khóa học không tồn tại.");
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return null;
        }
        return course;
    }

    // =========================================================================
    // 1. COURSE CHECKOUT (Item 1 - Refactored: Ngắn gọn, loại bỏ lặp mã)
    // =========================================================================

    private void showCheckout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String flashErr = SessionUtil.popFlashError(req);
        if (flashErr != null) {
            req.setAttribute("errorMessage", flashErr);
        }
        Long courseId = resolveCourseId(req);
        Course course = getValidCourseOrRedirect(req, resp, courseId, currentUser, true);
        if (course == null) return;

        req.setAttribute("course", course);
        req.getRequestDispatcher("/WEB-INF/views/registration/checkout.jsp").forward(req, resp);
    }

    private void processCheckout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        Long courseId = resolveCourseId(req);
        Course course = getValidCourseOrRedirect(req, resp, courseId, currentUser, false);
        if (course == null) return;

        try {
            String certName = req.getParameter("certificateName");
            if (certName == null || certName.trim().isEmpty()) {
                certName = currentUser.getFullName();
            }
            String phone = req.getParameter("studentPhone");
            String requestVat = req.getParameter("requestVat");
            String vatCompany = req.getParameter("vatCompany");
            String vatTaxCode = req.getParameter("vatTaxCode");
            String vatAddress = req.getParameter("vatAddress");

            BigDecimal finalPrice = course.getPrice() != null ? course.getPrice() : BigDecimal.ZERO;

            Map<String, Object> checkoutData = new HashMap<>();
            checkoutData.put("certName", certName.trim());
            checkoutData.put("phone", phone != null ? phone.trim() : "");
            checkoutData.put("finalPrice", finalPrice);
            checkoutData.put("requestVat", "on".equalsIgnoreCase(requestVat) || "true".equalsIgnoreCase(requestVat));
            checkoutData.put("vatCompany", vatCompany != null ? vatCompany.trim() : "");
            checkoutData.put("vatTaxCode", vatTaxCode != null ? vatTaxCode.trim() : "");
            checkoutData.put("vatAddress", vatAddress != null ? vatAddress.trim() : "");
            req.getSession().setAttribute("CHECKOUT_" + courseId, checkoutData);

            RegistrationDto reg = registrationService.enroll(currentUser.getId(), courseId, finalPrice);

            if (finalPrice.compareTo(BigDecimal.ZERO) <= 0 || reg.getStatus() == RegistrationStatus.ACTIVE) {
                SessionUtil.setFlashSuccess(req, "Đăng ký khóa học miễn phí thành công! Chào mừng bạn bắt đầu học tập.");
                resp.sendRedirect(req.getContextPath() + "/courses/learn?courseId=" + courseId);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/registrations/payment?courseId=" + courseId);
        } catch (Exception e) {
            SessionUtil.setFlashError(req, "Lỗi xử lý xác nhận đơn hàng: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/registrations/checkout?courseId=" + courseId);
        }
    }

    // =========================================================================
    // 2. ONLINE PAYMENT (Item 2 - Refactored: Query trực tiếp đơn PENDING)
    // =========================================================================

    private void showPayment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        Long courseId = resolveCourseId(req);
        Course course = getValidCourseOrRedirect(req, resp, courseId, currentUser, true);
        if (course == null) return;

        // [Tối ưu Item 2]: Truy vấn trực tiếp đơn PENDING duy nhất, không duyệt toàn bộ danh sách đăng ký
        RegistrationDto pendingReg = registrationService.getPendingRegistration(currentUser.getId(), courseId).orElse(null);

        @SuppressWarnings("unchecked")
        Map<String, Object> checkoutData = (Map<String, Object>) req.getSession().getAttribute("CHECKOUT_" + courseId);

        String certName = checkoutData != null && checkoutData.get("certName") != null
                ? (String) checkoutData.get("certName") : currentUser.getFullName();
        String phone = checkoutData != null && checkoutData.get("phone") != null
                ? (String) checkoutData.get("phone") : (currentUser.getPhone() != null ? currentUser.getPhone() : "");
        BigDecimal finalAmount = course.getPrice() != null ? course.getPrice() : BigDecimal.ZERO;
        if (pendingReg != null && pendingReg.getPaymentAmount() != null) {
            finalAmount = pendingReg.getPaymentAmount();
        } else if (checkoutData != null && checkoutData.get("finalPrice") != null) {
            finalAmount = (BigDecimal) checkoutData.get("finalPrice");
        }

        req.setAttribute("course", course);
        req.setAttribute("registration", pendingReg);
        req.setAttribute("certName", certName);
        req.setAttribute("phone", phone);
        req.setAttribute("finalAmount", finalAmount);
        req.setAttribute("paymentCode", pendingReg != null && pendingReg.getPaymentCode() != null
                ? pendingReg.getPaymentCode() : ("CR" + System.currentTimeMillis() % 1000000));
        req.getRequestDispatcher("/WEB-INF/views/registration/payment.jsp").forward(req, resp);
    }

    /**
     * Khởi tạo giao dịch thanh toán qua VNPay Sandbox
     */
    private void createVnPayPayment(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        Long courseId = resolveCourseId(req);
        if (courseId == null) {
            resp.sendRedirect(req.getContextPath() + "/courses/catalog");
            return;
        }

        try {
            BigDecimal finalPrice = null;
            Object checkoutObj = req.getSession().getAttribute("CHECKOUT_" + courseId);
            if (checkoutObj instanceof Map) {
                @SuppressWarnings("unchecked")
                Map<String, Object> map = (Map<String, Object>) checkoutObj;
                finalPrice = (BigDecimal) map.get("finalPrice");
            }
            if (finalPrice == null) {
                // [Tối ưu Item 2]: Lấy trực tiếp đơn PENDING
                RegistrationDto pending = registrationService.getPendingRegistration(currentUser.getId(), courseId).orElse(null);
                if (pending != null) {
                    finalPrice = pending.getPaymentAmount();
                }
            }
            RegistrationDto reg = registrationService.enroll(currentUser.getId(), courseId, finalPrice);

            if (reg.getStatus() == RegistrationStatus.ACTIVE) {
                SessionUtil.setFlashSuccess(req, "Khóa học đã được kích hoạt thành công!");
                resp.sendRedirect(req.getContextPath() + "/courses/learn?registrationId=" + reg.getId());
                return;
            }

            String bankCode = req.getParameter("bankCode");
            if (bankCode == null || bankCode.trim().isEmpty()) {
                bankCode = "NCB";
            } else if ("ALL".equalsIgnoreCase(bankCode.trim())) {
                bankCode = null;
            }

            String orderInfo = "Thanh toan khoa hoc #" + reg.getCourseId() + " Ma don #" + reg.getId();
            String vnpayUrl = VnPayUtil.createPaymentUrl(req, reg.getId(), reg.getPaymentAmount(), orderInfo, bankCode);

            resp.sendRedirect(vnpayUrl);
        } catch (Exception e) {
            SessionUtil.setFlashError(req, "Không thể khởi tạo cổng thanh toán VNPay: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/registrations/payment?courseId=" + courseId);
        }
    }

    // =========================================================================
    // 3. VNPAY RETURN & WEBHOOK (Item 3 - Refactored: Đã chuyển sang VnPayService)
    // =========================================================================

    private void paymentReturn(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        VnPayReturnOutcome outcome = vnPayService.handleReturn(req.getParameterMap(), currentUser);
        if (outcome.isFlashSuccess()) {
            SessionUtil.setFlashSuccess(req, outcome.getMessage());
        } else {
            SessionUtil.setFlashError(req, outcome.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + outcome.getRedirectPath());
    }

    private void paymentCallback(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String responseJson = vnPayService.handleIpn(req.getParameterMap());
        resp.getWriter().write(responseJson);
    }

    // =========================================================================
    // 10. STUDENT DASHBOARD (Item 10 - Refactored: Không block Gemini đồng bộ)
    // =========================================================================

    private void showMyRegistrations(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String flashError = SessionUtil.popFlashError(req);
        if (flashError != null) req.setAttribute("errorMessage", flashError);
        String flashSuccess = SessionUtil.popFlashSuccess(req);
        if (flashSuccess != null) req.setAttribute("successMessage", flashSuccess);

        List<RegistrationDto> list = registrationService.getByUser(currentUser.getId());
        RegistrationService.StudentDashboardStats stats = registrationService.calculateDashboardStats(list);
        RecentLearningDto recentLearning = registrationService.getRecentLearning(currentUser.getId());

        req.setAttribute("registrations", list);
        req.setAttribute("recentLearning", recentLearning);
        req.setAttribute("totalCourses", stats.totalCourses);
        req.setAttribute("inProgressCourses", stats.inProgressCourses);
        req.setAttribute("completedCourses", stats.completedCourses);
        req.setAttribute("pendingCourses", stats.pendingCourses);
        req.setAttribute("avgProgress", stats.avgProgress);
        req.setAttribute("totalCompletedLessons", stats.totalCompletedLessons);
        req.setAttribute("categories", stats.categories);

        req.getRequestDispatcher("/WEB-INF/views/registration/my.jsp").forward(req, resp);
    }

    // =========================================================================
    // 9. MY COURSE DETAIL (Item 9 - Refactored: Nạp đầy đủ đề cương & tiến độ)
    // =========================================================================

    private void showRegistrationDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
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
            long regId = Long.parseLong(idStr.trim());
            RegistrationDto registration = registrationService.getById(regId);
            if (registration == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đăng ký.");
                return;
            }
            if (!registrationService.canViewRegistration(registration, currentUser)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem đăng ký này.");
                return;
            }

            // [Tối ưu Item 9]: Tách rõ ràng dữ liệu Trang Tiến Độ (Detail) và Trang Học (Learn).
            // Nạp cấu trúc khóa học kèm trạng thái tiến độ từng bài học cho trang Detail
            try {
                CourseDto courseProgress = courseService.getLearningContent(regId, registration.getUserId());
                req.setAttribute("course", courseProgress);
            } catch (Exception e) {
                req.setAttribute("course", courseService.getCourseSummaryWithModules(registration.getCourseId()));
            }

            req.setAttribute("registration", registration);
            req.getRequestDispatcher("/WEB-INF/views/registration/detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đăng ký không hợp lệ.");
        }
    }

    // =========================================================================
    // OTHER MANAGEMENT ACTIONS
    // =========================================================================

    private void showCourseRegistrations(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        List<RegistrationDto> filteredList = new java.util.ArrayList<>();
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

    private void cancel(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                registrationService.cancel(Long.parseLong(idStr), currentUser.getId());
            } catch (SecurityException e) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/registrations/my");
    }

    private void updateRegistrationStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserDto currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null || (!"ADMIN".equalsIgnoreCase(currentUser.getRoleName()) && !"MANAGER".equalsIgnoreCase(currentUser.getRoleName()))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện thao tác này.");
            return;
        }
        String idStr = req.getParameter("id");
        String statusStr = req.getParameter("status");
        if (idStr != null && statusStr != null) {
            long regId = Long.parseLong(idStr);
            PaymentStatus pStatus = PaymentStatus.fromDb(statusStr);
            registrationService.updatePayment(regId, pStatus, "MANUAL-" + System.currentTimeMillis(),
                    OffsetDateTime.now());
        }
        resp.sendRedirect(req.getContextPath() + "/registrations/course");
    }
}
